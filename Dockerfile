FROM node:18.19.0-slim AS builder
WORKDIR app
COPY package*.json .
COPY yarn.lock .
RUN yarn install
COPY . .
RUN yarn build

FROM node:18.19.0-slim AS web
WORKDIR web
ENV PORT=80
COPY --from=builder /app/.next/standalone .
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

EXPOSE 80

CMD ["node", "server.js"]
