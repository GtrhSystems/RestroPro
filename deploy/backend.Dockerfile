FROM node:22-bookworm
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
RUN rm -f .env && mkdir -p tmp public
ENV NODE_ENV=production PORT=3000
EXPOSE 3000
CMD ["node", "index.js"]
