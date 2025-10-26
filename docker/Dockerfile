# builder: compile TypeScript and produce /app/dist
FROM node:18-alpine AS builder
WORKDIR /app

# Install build deps (only what's needed to build)
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

# Optional: remove devDependencies to reduce /app/node_modules size
RUN npm prune --production

# final: minimal runtime image
FROM node:18-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production

# Copy only production node_modules and built artifacts
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Use a non-root user if you want; Alpine requires extra setup for non-root users
# USER node

CMD ["node", "dist/server.js"]