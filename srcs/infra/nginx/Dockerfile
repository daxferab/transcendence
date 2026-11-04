# ------------------------------------ Node image for React app
FROM node:24-alpine AS builder

WORKDIR /app

# Copy packages first (cache optimization)
COPY apps/web/package*.json ./

# Install dependencies
# npm ci faster and better than npm install
RUN npm ci

# Copy font code
COPY apps/web/ ./

# Build React app (Translates JSX to plain html/css/js into dist/)
RUN npm run build

# ------------------------------------ NGINX
FROM nginx:alpine

# Delete default files
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

# Copy build (dist/)
COPY --from=builder /app/dist /usr/share/nginx/html

RUN	mkdir /etc/nginx/ssl && \
	openssl req \
		-x509 \
		-noenc \
		-keyout /etc/nginx/ssl/private.key \
		-out /etc/nginx/ssl/public.crt \
		-subj "/C=/ST=/L=/O=/OU=/CN=localhost"

COPY infra/nginx/conf/server.conf /etc/nginx/conf.d/server.conf

EXPOSE 443
