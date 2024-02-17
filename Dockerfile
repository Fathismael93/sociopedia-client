FROM node:alpine3.18 as build

# Declare build time environment variables
ARG VITE_SERVER_URL

# Serve default values for environment variables
ENV VITE_SERVER_URL=$VITE_SERVER_URL

# Build App
WORKDIR /app
COPY package*.json .
RUN npm install
COPY . .
RUN npm run build

# Serve with Nginx
FROM nginx:1.23-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf *
COPY --from=build /app/dist /usr/share/nginx/html
COPY package.json .
COPY vite.config.js .
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "deamon off;" ]