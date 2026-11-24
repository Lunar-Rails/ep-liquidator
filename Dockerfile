FROM golang:1.26-alpine AS builder
    WORKDIR /src/
    COPY . .
    RUN go get -d -v ./...
    RUN go build -o liquidator

FROM alpine:3.23.2@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62
    RUN adduser -D ep
    RUN apk --no-cache add ca-certificates
    USER ep
    WORKDIR /home/ep
    COPY --from=builder /src/liquidator /usr/bin/liquidator
    EXPOSE 9000
    ENTRYPOINT ["liquidator"]