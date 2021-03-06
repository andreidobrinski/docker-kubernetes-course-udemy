Docker Ecosystem

- Docker Client (CLI)
- Docker Server (Daemon)
- Docker Machine
- Docker Images
- Docker Hub
- Docker Compose

Image

- single file with all dependencies and config to run a program

Kernel

- intermediate layer between programs and hard drive, CPU or memory
- programs (processes) talk to kernel via system call

Namespacing

- OS feature
- segment out portion of HD to house different versions of software (versions Python for eg)
- kernel will redirect to the correct namespace when segmentation is present
- isolate resources for a certain process

Control Groups

- limit the amount of resources per process
  - resources like memor, CPU usage etc

Container

- a process or set of process with namespaced resources for running it

Image

- filesystem snapshot with a startup command
  - snapshot of processes

CLI

`docker ps`

- list all running containers

`docker ps --all`

- list all containers ever created

`docker run` = `docker create` + `docker start`

`docker system prune`

- deletes stopped container and build cache

`docker start -a`

- log output of run through terminal with -a flag

`docker logs $id`

- gets record from logs emitted from that container

`docker stop $id`, `docker kill $id`

- stop terminates the signal, with cleanup grace period (SIGTERM)
- kill terminates signal immediately
- stop is preferred, kill is used if container is locked up
- with stop, if container doesn't stop in 10 sec, docker will run kill automatically

`docker exec -it $id redis-cli`

- runs `redis-cli` in the container with \$id in a fresh terminal window

`-it` flag

- is two flags:
  - `-i` connects what you type to standard in on the container
  - `-t` shows output text nicely formatted

`docker exec -it $id sh`

- runs a shell in the container with \$id
- control-d to leave if control-c doesn't work
- typing exit may also work
- can use zsh or bash instead of sh, depending on the container

`docker run -it $image sh`

- starts the image with a shell

Dockerfile

- plain text file with config to tell how container will run
- config goes to docker client > docker server > usable image
- Flow:

  - specify a base image
  - run commands for dependencies
  - startup command for image

  Run `docker build .` when running from a Dockerfile

  Docker builds will check cache before making fetch requests for dependencies

Run `docker build -t andreidobrinski/redis:latest .` to tag an image.

- convention is username/reponame:version(tag)
- can later be run with `docker run andreidobrinski/redis` without specifying a tag
- no tag specified = latest will run

`docker run -p 8080:8080 $imageId`

- routes port 8080 of our localhost to 8080 of container
- container port is on the right of the colon

`docker-compose up --build`

- runs docker-compose.yml from the current working directory
- `--build` will rebuild the images first

`docker-compose up -d`

- runs in the bg. lets your use the terminal instance after finished

`docker-compose down`

- stops running docker-compose instance

Restart policies

- "no": never restarts, not with stop or crash. specifically needs to be in quotes
- always: always attemps to restart
- on-failure: restarts only if container stops with an error code
- unless-stopped: always restart unless the dev force stops it

`docker build -f Dockerfile.dev .`

- build from dev dockerfile

`docker run -it -p 3000:3000 CONTAINER_ID`

- runs react project in container, maps to port 3000

`docker run -it -p 3000:3000 -v /app/node_modules -v $(pwd):/app CONTAINER_ID`

- run docker container
- maps ports to 3000
- reference local app folder except use node_modules from container
- allows for reloading like on regular local dev

`docker run -it $id npm run test`

- run interactive test in terminal window

`docker exec -it $id npm run test`

- run tests in existing running container

`docker run -p 8080:80 $id`

- for mapping nginx default port 80 to localhost 8080

Multi-Container Architecture

Elastic Beanstalk Instance

- Nginx (used for initial routing to either client or express server)
- client (FE React with another nginx)
- express server
- worker

AWS Elastic Cache

- Redis

AWS Relational Database Service (RDS)

- Postgres

Kubernetes

- runs different containers across machines
- manages different containers with different images
- best used when the conatiners differ from one another
- Cluster is formed from a 'master' with 'nodes'
- master manages the nodes created
  - developers only interact with the master, not with the individual nodes
- a node contains containers
- used in development with minikube
  - minikube manages VM (local only)
  - kubectl manages containers in node
- used in prod with a 'managed solution'
  - amazon elastic container services for kubernetes
  - google cloud kubenetes engine
  - roll your own
- all containers are built before kubernetes deals with them
  - images come from docker hub
- one config file per object
  - one config file for the container
- have to manually set up all networking (no port mapping like docker-compose)
  - one config file for networking
- a Node is a virtual machine in k8s

Kubernetes Object

- example object types: StatefulSet, ReplicaController, Pod, Service
- marked as `kind` in the yaml config
- can add multiple configs in the same file is separated with a line of `---`

Pod

- grouping of containers with a common purpose
- The smallest thing you can deploy since you can't deploy a single container like with Docker

Service

- to set up networking in a k8s cluster
- subtypes: ClusterIP, NodePort, LoadBalancer, Ingress.
  - NodePort: expose a container to the outside world (for dev only)
- objects are linked through label names
  - label inside pod and selector inside service
- ports should match
  - containerPort in pod and targetPort in service
  - nodePort is what port the browser uses. between 30000-32767
- services are useful to keep developing on the same local IP address if pods are deleted or changed
- ClusterIP helps connect Deployment objects within a node to other Deployment objects within that node
  - Does not allow traffic in from the outside
- LoadBalancer: legacy way of getting outside traffic into app. Prefer Ingress over this
- Ingress service handles traffic from outside and allows it into the kubernetes node
  - different implementations, this course uses Nginx Ingress `ingress-nginx`, not `kubernetes-ingress`
  - ingress-nginx setup is different depending on env (local, GC, AWS etc)
  - ingress config is the set of rules
  - feeds into the ingress controller, which accepts incoming traffic (not accurate for all projects but is the case in this course)
    - controller usually implements config but doesnt accept traffic

Installing Ingress

- install link for docker [desktop](https://kubernetes.github.io/ingress-nginx/deploy/#docker-for-mac)
- verify installation: `kubectl get pods -n ingress-nginx`

apiVersion

- defines a different set of objects we can use

Deployments 2 types:

1. Imperative Deployments

- do exactly these steps to arrive at this container setup
- involves computing current state, desired state and migration path between the two states

2. Declarative Deployments

- container setup should look like this. make it happen
- is not concerned with the current state
- sends a config file to kubernetes to deal with how handle current state and migration path
- usually the preferred approach
- fails when updating only a port on a config. only certain fields are allowed to be updated
  - changing Pod to Deployment object type fixes this

Pods vs Deployment

- runs a single set of containers / runs a set of identical pods
- good for dev purposes / good for dev and prod
- Deployment monitors the state of pods and updates if necessary

No easy way to update an image in a k8s config file

- cant use env vars in config file
- can tag built images with a version number and reference that version in the k8s config
  - adds an extra step to deploys
- use an imperative command to update the image version
  - need to tag images with version when pushing up to docker hub

Why to connect to the version of Docker in the VM Node?

- have access to all docker debugging CLI tools
- manually kill docker to test k8s restart
- delete cached images in the node

Postgres PVC

- PVC: Persistent Volume Claim
- when a pod crashes, the data gets lost with it
- a new pod is created without any data carried over
  - data gets lost with a crash
  - PVC helps prevent this

k8s Volume

- generic terminology: some type of mechanism that allows a container to access a filesystem outside itself
- in k8s: an object that allows a container to store persistent data at the pod level
  - can be accessed by any container inside the pod
  - volume lives inside the pod
  - volume is tied to pod. if pod dies, the volume inside dies.

Persistent Volume

- not tied to any specific pod or container
- can stay alive if a pod or container that's tied to it goes down

Persistent Volume Claim

- storage options: statically provisioned persistent volume and dynamically provisioned persistent volume
  - statically provisioned is created ahead of time, before the pod config asks for it
  - dynamically gets created JIT when pod config asks for it
- PVC is the storage options, the config decides which one it needs
  - on local (dev) it's the hard drive
  - on the cloud, there are options based on the cloud provider

PVC Access Modes

- ReadWriteOnce: can be used by a single node
- ReadOnlyMany: multiple nodes can read it
- ReadWriteMany: multiple nodes can read and write

Secrets

- create a secret using an imperative command
- need to create the secret for every environment
- used for PGPASSWORD:
  - `kubectl create secret generic secret_name --from-literal key=value`

Using a Git SHA for unique image ids sent to docker

- each push generates a unique id
- ability to checkout a SHA for debugging purposes

Role-based Access Control (RBAC)

- User Accounts
  - a person admin on the cluster
  - identifies a person
- Service Accounts
  - a pod admin on the cluster
  - identifies a program
- ClusterRoleBinding
  - authorizes an account to do a certain set of actions on the cluster
- RoleBinding
  - authorizes an account to do a certain set in a single namespace
  - lets a user or service do things

Skaffold

- for local development in a k8s environment
