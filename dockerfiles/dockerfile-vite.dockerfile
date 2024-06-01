FROM node:19.4-bullseye as build

WORKDIR /user/src/app

COPY package.json ./

RUN --mount=type=cache, target=/usr/src/app/npm \
    npm set cache /usr/src/app/.npm && \
    npm ci

COPY . .

RUN npm run build

FROM nginx:1.22-alpine

COPY nginx.conf /etc/nginx/nginx.conf

RUN --mount=type=secret,id=secret.txt, dst=/container-secret.txt

COPY --from=build usr/src/app/dist/ /usr/share/nginx/html

CMD [ "npm", "run", "dev" ]