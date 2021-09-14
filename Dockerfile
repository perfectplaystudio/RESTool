FROM node:12
USER node
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin
WORKDIR /home/node
COPY package.json .
COPY package-lock.json .
COPY tsconfig.json .
COPY --chown=node:node ./src ./src
COPY --chown=node:node ./public ./public
RUN npm i --only=prod && npm rebuild node-sass && npm audit fix --force
EXPOSE 3000
#ENTRYPOINT ["npm", "start"]
CMD cp /tmp/config.json ./public/config.json && npm start