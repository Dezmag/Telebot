# Build stage
FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o telebot .

# Runtime stage
FROM alpine:3.22

WORKDIR /root/

COPY --from=builder /app/telebot .

RUN adduser -D appuser

USER appuser

CMD ["./telebot"]