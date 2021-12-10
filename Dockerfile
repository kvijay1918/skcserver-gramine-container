FROM ubuntu:18.04

RUN apt-get update 

COPY skcserver /bin/

CMD ["/bin/skcserver"]