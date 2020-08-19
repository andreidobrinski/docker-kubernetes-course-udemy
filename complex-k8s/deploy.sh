docker build -t DOCKER_ID/CLIENT -f ./client/Dockerfile ./client
docker build -t DOCKER_ID/SERVER -f ./server/Dockerfile ./server
docker build -t DOCKER_ID/WORKER -f ./worker/Dockerfile ./worker
docker push DOCKER_ID/CLIENT
docker push DOCKER_ID/SERVER
docker push DOCKER_ID/WORKER
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=DOCKER_ID/SERVER