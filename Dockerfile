FROM alpine:latest

MAINTAINER Teddy Fontaine Sheol version: 0.1

ENV APP_HOME=/opt/app

RUN apk upgrade --update && apk add curl bash make git docker

WORKDIR $APP_HOME

RUN git clone "https://github.com/docker/docker-ce.git"

WORKDIR $APP_HOME/"docker-ce/components/packaging/static"

ENTRYPOINT ["sh", "-c"]
CMD ["(dockerd &); sleep 2; pwd; make cross-win"]