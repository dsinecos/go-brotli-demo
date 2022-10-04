# Cannot use alpine images as it doesn't have apt which is needed to install other dependencies
# FROM public.ecr.aws/docker/library/golang:1.18.2-alpine AS gobuild
FROM golang:1.18.6 AS gobuild

WORKDIR /go-brotli-demo

RUN apt-get update -y \
  && apt-get install -y cmake

RUN cd /usr/local \
  && git clone https://github.com/google/brotli \
  && cd brotli && mkdir out && cd out && ../configure-cmake --disable-debug \
  && make \
  && make install

COPY . .

RUN go build -o brotli-demo -mod=vendor .

FROM public.ecr.aws/docker/library/alpine:3.15

# @TODO - What does the following command do?
RUN apk --no-cache add --update ca-certificates libc6-compat

COPY --from=gobuild /usr/local/lib /usr/local/lib
COPY --from=gobuild /go-brotli-demo/brotli-demo .

RUN ./brotli-demo