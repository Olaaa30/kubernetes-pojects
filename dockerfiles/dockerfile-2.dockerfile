FROM golang:1.19-buster as build

WORKDIR /app

#-u as in userid
RUN useradd -u 1001 nonroot

#we can now make changes to our app without invalidating the cache
# before downloading dependencies
COPY go.mod go.sum ./

## Cache mount for go modules
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache, target=/root/.cache/go-build \
     go mod download

COPY . .

# create a binary that will have allthe dependencies installed
RUN go build \
    -ldflags="-linkmode external -extldflags -static" \
    -tags netgo \
    -o api-golang

#####
FROM scratch

##Set env for GIN, which is the framework we are using with go
ENV GIN_MODE=release

COPY --from=build /etc/passwd /etc/passwd

COPY --from=build /app/api-golang /api-golang

EXPOSE 8080

CMD [ "./api-goland" ]