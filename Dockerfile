FROM node:12-stretch AS builder

RUN \
  apt-get update && apt-get install -y \
    g++ \
    git \
    make \
    python && \
  mkdir -p /usr/src/node_modules && \
  chown -R node:node /usr/src

WORKDIR /usr/src

COPY package*.json ./

USER node

RUN npm install



FROM lsiobase/alpine:3.12

LABEL maintainer="Griefed <griefed@griefed.de>"

ENV DRSS_BOT_TOKEN='drss_docker_token' \
    DRSS_DATABASE_URI='mongodb://mongo:27017/rss'

RUN \
  apk add --no-cache --update \
  nodejs=12.20.1-r0 && \
  mkdir -p \
    /app/monitorss

COPY --from=builder /usr/src /app/monitorss/.
COPY . /app/monitorss/.
COPY root/ /

RUN \
  rm -Rf /app/monitorss/root && \
  echo "**** Cleanup ****" && \
    rm -rf \
      /root/.cache \
      /tmp/*

VOLUME /config

EXPOSE 8081