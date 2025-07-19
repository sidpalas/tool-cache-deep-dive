FROM node:20.19.2-bookworm-slim AS install-deps
WORKDIR /usr/src/app
COPY package*.json ./

###################################
FROM install-deps AS which-and-version
RUN which node && node -v

###################################
FROM install-deps AS test
RUN npm ci 
COPY ./src/ .
ARG FAIL_OR_SUCCEED
RUN npm run test-${FAIL_OR_SUCCEED}

###################################
FROM install-deps AS deploy
ENV NODE_ENV=production
RUN npm ci --production
USER node
COPY --chown=node:node ./src/ .
EXPOSE 3000
CMD [ "node", "index.js" ]
