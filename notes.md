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
