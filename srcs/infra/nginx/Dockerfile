# Docker context srcs/
# ------------------------------------ Node image for React app
FROM node:24-alpine AS builder

WORKDIR /app


# Copy packages first (cache optimization)
COPY package*.json ./
COPY apps/web/package*.json ./apps/web/
#uncomment once packages/shared exists:
#	COPY packages/shared/package*.json ./packages/shared/

# Update "npm"
# Install dependencies
# npm ci faster and better than npm install
RUN npm install -g && npm ci

# Copy font code
COPY apps/web/ ./apps/web/
#uncomment once packages/shared exists:
#	COPY packages/shared/ ./packages/shared/

# Build React app (Translates JSX to plain html/css/js into dist/)
RUN npm run build

# ------------------------------------ NGINX
FROM nginx:alpine

# Delete default files
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

# Copy build (dist/)
COPY --from=builder /app/apps/web/dist /usr/share/nginx/html

RUN   mkdir -p /etc/nginx/ssl
COPY infra/nginx/ssl /etc/nginx/ssl

RUN rm -f /etc/nginx/conf.d/default.conf
COPY infra/nginx/conf/server.conf /etc/nginx/conf.d/server.conf

EXPOSE 80
