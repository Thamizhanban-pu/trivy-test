# Stage 1: Build the Go binary
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /go-app main.go

# Stage 2: Final minimal image for production
FROM gcr.io/distroless/static-debian12:latest
COPY --from=builder /go-app /go-app
EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/go-app"]
