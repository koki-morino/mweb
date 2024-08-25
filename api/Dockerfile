FROM golang:1.23 AS build

WORKDIR /

COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o ./api

FROM gcr.io/distroless/static-debian12
COPY --from=build /api /
CMD ["/api"]

# docker build -t kokimorino/mweb-api:latest .
# docker push kokimorino/mweb-api:latest
