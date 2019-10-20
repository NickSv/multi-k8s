# build images from Dockerfiles of respective folders with 2 tags for each image
docker build -t nicksv/multi-client:latest -t nicksv/multi-client:$SHA ./client
docker build -t nicksv/multi-worker:latest -t nicksv/multi-worker:$SHA ./worker
docker build -t nicksv/multi-server:latest -t nicksv/multi-server:$SHA ./server

# push images to DockerHub with both tags for each image
docker push nicksv/multi-client:latest
docker push nicksv/multi-worker:latest
docker push nicksv/multi-server:latest
docker push nicksv/multi-client:$SHA
docker push nicksv/multi-worker:$SHA
docker push nicksv/multi-server:$SHA

# apply all k8s config files from /k8s folder
kubectl apply -f k8s

# imperatively tell k8s Master to run specific deployments based on latest images
kubectl set image deployments/server-deployment server=nicksv/multi-server:$SHA
kubectl set image deployments/client-deployment client=nicksv/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=nicksv/multi-worker:$SHA