# Stage 1: Build the React front end
FROM node:20-slim AS build
WORKDIR /app/client
COPY client/package*.json ./
RUN npm ci
COPY client/ ./
RUN npm run build

# Stage 2: run the API, which also serves the built front end
FROM node:20-slim AS runtime
WORKDIR /app/server

ARG APP_VERSION=V1
ENV APP_VERSION=$APP_VERSION

COPY --from=build /app/client/dist /app/client/dist

EXPOSE 3001
CMD ["node", "server.js"]   