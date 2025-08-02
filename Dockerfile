FROM oven/bun:1.1

WORKDIR /app

COPY package.json package.json
COPY bun.lock bun.lock

COPY prisma ./prisma
COPY src ./src

RUN bun install
RUN bunx prisma generate --schema=./prisma/schema.prisma

COPY . .

ENV PORT=8000

EXPOSE 8000

CMD ["bun", "src/index.ts"]