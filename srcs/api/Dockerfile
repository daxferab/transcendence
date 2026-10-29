# 1. Base image: Node.js 22 on lightweight Alpine Linux
FROM node:22-alpine

# 2. Set the working directory inside the container
WORKDIR /usr/src/app

# 3. Copy package manifests first to leverage Docker layer caching
COPY package*.json ./

# 4. Install all dependencies (including devDependencies for TypeScript compilation)
RUN npm ci

# 5. Copy the rest of the source code
COPY . .

# 6. Build the production TypeScript bundle
RUN npm run build

# 7. Document the backend listening port
EXPOSE 3000

# 8. Start the NestJS application
CMD ["npm", "run", "start:prod"]
