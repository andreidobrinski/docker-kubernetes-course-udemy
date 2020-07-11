# Specify a base image
FROM node:alpine

WORKDIR /usr/app

# Install deps
COPY ./ ./
RUN npm install

# Default command
CMD ["npm", "start"]