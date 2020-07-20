FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
# or, refactored for AWS
# COPY package*.json ./
# 
RUN npm install
COPY . .
RUN npm run build

FROM nginx
# expose works for elastic beanstalk
# EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html
# unnamed builder (for AWS)
# COPY --from=0 /app/build /usr/share/nginx/html