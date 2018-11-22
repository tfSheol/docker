FROM alpine:latest

MAINTAINER Teddy Fontaine Sheol version: 0.1

ARG DOCKER_V
ENV APP_HOME=/opt/app

RUN apk upgrade --update && apk add curl bash make git docker
WORKDIR $APP_HOME

RUN echo ${DOCKER_V}

RUN git clone "https://github.com/docker/docker-ce.git" --branch ${DOCKER_V} --single-branch --depth 1
WORKDIR $APP_HOME/"docker-ce/components/packaging/static"

ENTRYPOINT ["sh", "-c"]
CMD ["(dockerd &); sleep 2; pwd; make cross-win"]