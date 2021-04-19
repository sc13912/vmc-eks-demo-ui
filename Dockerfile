# pull official base image
# FROM node:15.8.0-alpine3.10

FROM nginx:1.19.6-alpine

# WORKDIR /app

# COPY build /app/build
# RUN yarn global add serve

WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
# Copy static assets from builder stage
COPY build .
ADD start.sh start.sh

# ENV UI_ENV=prod 
RUN chmod +x start.sh

# ENTRYPOINT ["nginx", "-g", "daemon off;"]
RUN apk add --no-cache --upgrade bash
CMD ["./start.sh"]

# CMD ["serve", "-p", "80", "-s", "build"]
# CMD ["sh"]
