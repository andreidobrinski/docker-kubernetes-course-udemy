docker build -t DOCKER_ID/CLIENT:latest -t DOCKER_ID/CLIENT:$SHA -f ./client/Dockerfile ./client
docker build -t DOCKER_ID/SERVER:latest -t DOCKER_ID/SERVER:$SHA -f ./server/Dockerfile ./server
docker build -t DOCKER_ID/WORKER:latest -t DOCKER_ID/WORKER:$SHA -f ./worker/Dockerfile ./worker
docker push DOCKER_ID/CLIENT:latest
docker push DOCKER_ID/SERVER:latest
docker push DOCKER_ID/WORKER:latest
docker push DOCKER_ID/CLIENT:$SHA
docker push DOCKER_ID/SERVER:$SHA
docker push DOCKER_ID/WORKER:$SHA
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=DOCKER_ID/SERVER:$SHA
kubectl set image deployments/client-deployment server=DOCKER_ID/CLIENT:$SHA
kubectl set image deployments/worker-deployment server=DOCKER_ID/WORKER:$SHA