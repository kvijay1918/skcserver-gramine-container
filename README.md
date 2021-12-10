# skcserver-gramine-container
Running gramine skc server in a container

1. Clone the gsc source

git clone https://github.com/gramineproject/gsc.git

2. cd gsc

3. Create a folder.(Name can be whatever. I named it as skcserver)

4. Copy the server executable to gsc/skcserver

5. Clone the skcserver-gramine-container repo.

git clone https://github.com/kvijay1918/skcserver-gramine-container.git

6. cd skcserver-gramine-container

7. Copy Makefile, enclave-key.pem and skcserver.manifest.template files to gsc/skcserver

cp Makefile skcserver.manifest.template enclave-key.pem /root/gsc/server

8. Navigate /root/gsc

9. Do docker build

docker build --tag skcserver --file skcserver/Dockerfile .

10. Make sure the skcserver image generated.

root@a4bf01694f20:~/root/gsc# docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE

skcserver           latest              23b37c2baaaa        9 seconds ago       113MB

ubuntu              18.04               5a214d77f5d7        2 months ago        63.1MB

11. Do GSC build on the generated docker image.

./gsc build --insecure-args skcserver  skcserver/skcserver.manifest

12. Make sure it generates an unsigned graminized Docker image `gsc-skcserver-unsigned` from original application image `skcserver` successfully.

13. Do sign image.

./gsc sign-image skcserver skcserver/enclave-key.pem

14. Make sure it generates a signed Docker image `gsc-skcserver` from `gsc-skcserver-unsigned` successfully.

15. Verify the info of the generated image.

./gsc info-image gsc-skcserver

16. Finally run the docker container.

docker run -d -p 50051:50051 --device=/dev/sgx_enclave -v /var/run/aesmd/aesm.socket:/var/run/aesmd/aesm.socket gsc-skcserver

(If need trace messages, don't run it in detached mode. Remove -d from the above command)

17. Make sure the container is up and running.

root@a4bf01694f20:# docker ps -a

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS                      NAMES

cacb285b8615        gsc-skcserver       "/bin/bash /apploade…"   4 seconds ago       Up 2 seconds                  0.0.0.0:50051->50051/tcp   cool_tesla