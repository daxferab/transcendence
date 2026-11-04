FROM node:22-alpine

WORKDIR /usr/src/app

# COPY package*.json ./

# RUN npm ci

COPY . .

EXPOSE 5173

# Uncomment once package.json is initialized:
# CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "5173"]

# Keep container alive while frontend is being set up:
CMD ["tail", "-f", "/dev/null"]
