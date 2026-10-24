FROM node:24-slim

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

RUN pnpm install --ignore-scripts

EXPOSE 3080

CMD ["pnpm", "run", "start:web"]