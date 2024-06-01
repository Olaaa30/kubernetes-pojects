# test config for a nodejs api
FROM node:19.6-alpine

WORKDIR /the/workdir/path

ENV NODE_ENV production

COPY package*.json ./
#option to mount a cache location
RUN npm ci --only=production

USER node

COPY --chown=node:node ./src .

EXPOSE 3000

CMD [ "node", "index.js" ]
