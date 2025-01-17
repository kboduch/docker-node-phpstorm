FROM node:20-bookworm-slim@sha256:8d26608b65edb3b0a0e1958a0a5a45209524c4df54bbe21a4ca53548bc97a3a5 AS base

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV NODE_ENV=production
ENV NPM_CONFIG_LOGLEVEL=info

ARG TARGET_ARCH
ARG TARGET_ARCH=${TARGET_ARCH:-arm64}

ENV TINI_VERSION=v0.19.0
ADD --chmod=755 https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-${TARGET_ARCH} /usr/local/bin/tini

EXPOSE 3000
USER node
WORKDIR /app

COPY --chown=node:node package*.json ./
RUN npm ci --omit=dev && npm cache clean --force
ENV PATH=/home/node/.npm-global/bin:$PATH
ENV PATH=/app/node_modules/.bin:$PATH

FROM base AS dev
ENV NODE_ENV=development
RUN npm install
COPY --chown=node:node . .
CMD ["nodemon",  "--inspect=0.0.0.0:9229", "./src/index.js"]

FROM base AS prod
COPY --chown=node:node . .
ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["node", "./src/index.js"]

## todo healthcheck
