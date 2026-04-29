# ---------- build stage ----------
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Копіюємо go.mod і go.sum окремо (кешування залежностей)
COPY go.mod go.sum ./
RUN go mod download

# Копіюємо весь код
COPY . .

# Збираємо бінарник
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o tbot -ldflags="-s -w -X my-telegram-bot/cmd.appVersion=dev" ./cmd

# ---------- runtime stage ----------
FROM alpine:latest

WORKDIR /app

# Копіюємо тільки бінарник
COPY --from=builder /app/tbot .

# (опційно) сертифікати для HTTPS
RUN apk add --no-cache ca-certificates

# Запуск
CMD ["./tbot"]