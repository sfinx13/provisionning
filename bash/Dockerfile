# syntax=docker/dockerfile:1

FROM ubuntu:20.04

RUN  mkdir /scripts

COPY provision.sh /scripts
WORKDIR /scripts
RUN chmod +x provision.sh

RUN ./provision.sh

CMD bash