# Specify a base image
FROM node:alpine

# Install deps
COPY ./ ./
RUN npm install

# Default command
CMD ["npm", "start"]