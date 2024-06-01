# test config for a nodejs api
FROM node:19.6-alpine

WORKDIR /the/workdir/path

COPY package*.json ./

RUN npm install

USER node

COPY --chown=node:node ./src .

EXPOSE 3000

CMD [ "node", "index.js" ]