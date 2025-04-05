# Stage 1: Build the Vue.js application
FROM node:18-alpine as build-stage

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy project files
COPY . .

# Build the Vue.js application
RUN npm run build

# Stage 2: Production stage with minimal dependencies
FROM node:18-alpine as production-stage

# Set working directory
WORKDIR /app

# Create a non-root user for security
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Copy package.json and package-lock.json
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy built app from build stage
COPY --from=build-stage /app/dist ./dist
COPY --from=build-stage /app/server.js ./server.js

# Set ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose the port
EXPOSE 3000

# Set environment variables
ENV NODE_ENV=production

# Start the server
CMD ["node", "server.js"] 