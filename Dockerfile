#Stage 1
FROM node:12 AS builder
USER node
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
WORKDIR /home/node
COPY package.json .
COPY package-lock.json .
COPY tsconfig.json .
COPY --chown=node:node ./src ./src
COPY --chown=node:node ./public ./public
RUN npm i --only=prod && npm rebuild node-sass && npm audit fix
RUN npm run build


#Stage 2
FROM nginx:1.19.0

#copies React to the container directory

# Set working directory to nginx resources directory
WORKDIR /usr/share/nginx/html

# Remove default nginx static resources
RUN rm -rf ./*

# Copies static resources from builder stage
COPY --from=builder /home/node/build/ /usr/share/nginx/html

EXPOSE 80

CMD cp /tmp/config.json /usr/share/nginx/html/config.json && nginx -g 'daemon off;'