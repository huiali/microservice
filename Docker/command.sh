docker --version
docker info
docker images
docker image ls
docker ps
docker container ls --all

docker build .
docker build -t <REPOSITORY>:<TAG> .
docker login <REGISTRY>
docker tag <IMAGE ID> <REPOSITORY>:<TAG>
docker push <REPOSITORY>:<TAG>
docker pull <REPOSITORY>:<TAG>
docker run <IMAGE ID>
docker attach <CONTAINER ID>
docker start <CONTAINER ID>
docker stop <CONTAINER ID>
docker logs <CONTAINER ID>