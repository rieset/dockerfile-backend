# Backend
FROM node:14-alpine

LABEL authors="Albert Iblyaminov <rieset@yandex.ru>, Max Mishin <max@mishin.io>" \
      org.label-schema.vendor="Untld Service" \
      org.label-schema.name="Untld Service Image" \
      org.label-schema.description="Untld Service" \
      org.label-schema.url="https://untld.pro" \
      org.label-schema.schema-version="1.0"

ENV NODE_ENV="production" \
    PORT="1337" \
    USER="app" \
    FRONTEND_INSTANCES="2" \
    FRONTEND_MEMORY="230M" \
    LABEL="Untld backend" \
    BUILD_DEPS="python make build-base gcc autoconf automake zlib-dev libpng-dev nasm bash" \
    RUNTIME_DEPS="" \
#    RUNTIME_DEPS="chromium nss freetype freetype-dev harfbuzz ca-certificates ttf-freefont" \
    NODE_OPTIONS="--max_old_space_size=2048"

RUN set -x && \
    apk add --update $RUNTIME_DEPS && \
    apk add --no-cache --virtual build_deps $BUILD_DEPS && \
    npm install pm2 -g && \
    addgroup -g 2000 app && \
    adduser -u 2000 -G app -s /bin/sh -D app

WORKDIR /home/$USER

USER $USER

COPY --chown=$USER:$USER . .

RUN yarn install --production=false && \
    yarn build

CMD ["pm2-runtime", "start", "./pm2.config.js"]
