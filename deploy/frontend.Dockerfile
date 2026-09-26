FROM node:22-bookworm AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
ARG PUBLIC_URL
RUN rm -f .env .env.local && printf 'VITE_BACKEND=%s/api/v1\nVITE_BACKEND_SOCKET_IO=%s\nVITE_BACKEND_IMAGES_BASE_URL=%s\nVITE_FRONTEND_DOMAIN=%s\nVITE_STRIPE_PRODUCT_SUBSCRIPTION_KEY=\n' "$PUBLIC_URL" "$PUBLIC_URL" "$PUBLIC_URL" "$PUBLIC_URL" > .env.production && npm run build

FROM nginx:1.27-alpine
COPY --from=deploy nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
