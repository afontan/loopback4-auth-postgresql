# Check out https://hub.docker.com/_/node to select a new base image
FROM node:10-slim

# Set to a non-root built-in user `node`
USER node

# Create app directory (with user `node`)
RUN mkdir -p /home/node/app

WORKDIR /home/node/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY --chown=node package*.json ./

RUN npm install

# Bundle app source code
COPY --chown=node . .

RUN npm run build

COPY wait-for-it.sh wait-for-it.sh
RUN chmod +x wait-for-it.sh

# Bind to all network interfaces so that it can be mapped to the host OS
ENV HOST=0.0.0.0 PORT=8080

EXPOSE ${PORT}
CMD [ "./wait-for-it.sh" , "[ENTER YOUR ENDPOINT HERE]" , "--strict" , "--timeout=300" , "--" , "node", ".", "npm run migrate" ]
