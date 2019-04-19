FROM golang:1.12.0-alpine3.9 as build

RUN apk add --update git
WORKDIR /app

COPY go.mod go.sum /app/
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags '-w -extldflags "-static"' -o app cmd/sql-agent/main.go

FROM scratch
COPY --from=0 /app/app .
CMD ["./app", "-host", "0.0.0.0"]
