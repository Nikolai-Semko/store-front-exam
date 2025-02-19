# Build stage
FROM node:18-alpine AS build-stage

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY babel.config.js ./
COPY jsconfig.json ./
COPY vue.config.js ./

# Install dependencies
RUN npm install

# Copy source files
COPY public ./public
COPY src ./src

# Set environment variables for services
ENV ORDER_SERVICE_URL=https://order-service.fake.net/
ENV PRODUCT_SERVICE_URL=https://product-service.fake.net/

# Build the app
RUN npm run build

# Production stage
FROM nginx:stable-alpine AS production-stage

# Copy built files from build stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]