#!/bin/bash
bash mount_disk.sh /dev/sdc /var/lib/docker
apt-get update
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
docker pull registry:2
mkdir -p /auth
docker run \
  --entrypoint htpasswd \
  registry:2 -Bbn {<username>} {<password>} > /auth/htpasswd
mkdir -p /certs
echo "$2" > certPass.txt
openssl pkcs12 -in $1 -passin file:certPass.txt -nodes -nokeys -out /certs/domain.crt
openssl pkcs12 -in $1 -passin file:certPass.txt -nocerts -nodes  -out /certs/domain.key
rm -f cic-pwd.txt
docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v /auth:/auth \
  -e REGISTRY_AUTH=htpasswd \
  -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v /certs:/certs \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  -p 443:443 \
  registry:2
