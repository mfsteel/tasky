# Building the binary of the App
FROM golang:1.19 AS build

CMD ["/bin/sh"]

ENV MONGO_URI=mongodb://admin:SecurePassword123@ec2-3-133-142-90.us-east-2.compute.amazonaws.com:27017/go-mongodb?authSource=admin
ENV SECRET_KEY=7cq0a5d9f67e9c0b4f3d2e1a8c7f6e5d4c3b2a1f0e9d8c7b6a5d9f67e9c0b4f3d2e1

WORKDIR /go/src/tasky
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/src/tasky/tasky


FROM alpine:3.17.0 as release

WORKDIR /app
COPY --from=build  /go/src/tasky/tasky .
COPY --from=build  /go/src/tasky/assets ./assets
EXPOSE 8080
ENTRYPOINT ["/app/tasky"]



