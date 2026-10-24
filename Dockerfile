FROM node:20-slim

RUN apt-get update && apt-get install -y \
    git \
    python3 \
    make \
    g++ \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g pnpm@11.28.5

WORKDIR /app

COPY . .

RUN if [ -d "plugins/harness-lark" ]; then rm -rf plugins/harness-lark; fi
RUN sed -i '/harness-lark/d' package.json || true

ENV NODE_OPTIONS="--max-old-space-size=4096"

RUN pnpm install

RUN pnpm run prepare:primary-runtime || true
RUN pnpm run build:web

EXPOSE 3080

CMD ["pnpm", "run", "start:web"]