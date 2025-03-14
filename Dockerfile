# Build stage
FROM nginx:alpine as build
RUN apk update && apk upgrade libxml2 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.21/main
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
