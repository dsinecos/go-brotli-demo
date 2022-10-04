# @TODO - Cannot use alpine images as it doesn't have apt which is needed to install other dependencies
# @TODO - Check which image is then suitable to use

# FROM public.ecr.aws/docker/library/golang:1.18.2-alpine AS gobuild
FROM golang:1.18.6 AS gobuild
# FROM golang:1.18.6-alpine3.16 AS gobuild

WORKDIR /go-brotli-demo

# RUN apk update \
#   && apk upgrade \
#   && apk add cmake git

# RUN git config --global --unset http.proxy
  # && git config --global --unset https.proxy

RUN apt-get update -y \
  && apt-get install -y cmake

# RUN apt update -y \
#   && apt install -y git build-essential cmake gcc make bc sed autoconf automake libtool git apt-transport-https

RUN cd /usr/local \
  && git clone https://github.com/google/brotli \
  && cd brotli && mkdir out && cd out && ../configure-cmake --disable-debug \
  && make \
  && make install

# @TODO - This doesn't seem to work (don't know why)
# RUN cd /usr/local \
#   && git clone https://github.com/google/brotli \
#   && cd brotli && mkdir out && cd out \
#   && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=./installed .. \
#   && cmake --build . --config Release --target install

# COPY go.mod .
# COPY go.sum .
# RUN go mod tidy

COPY . .

# RUN CGO_ENABLED=1 LD_LIBRARY_PATH='/usr/local/lib' \
#   go build -o brotli-demo -mod=vendor .
# RUN CGO_CFLAGS='-I /usr/local/include' CGO_LDFLAGS='-L /usrlocal/lib' go build -o brotli-demo -mod=vendor .
RUN go build -o brotli-demo -mod=vendor .

# FROM alpine:3.11
FROM public.ecr.aws/docker/library/alpine:3.15

# @TODO - What does the following command do?
RUN apk --no-cache add --update ca-certificates libc6-compat

COPY --from=gobuild /usr/local/lib /usr/local/lib
COPY --from=gobuild /go-brotli-demo/brotli-demo .

RUN ./brotli-demo