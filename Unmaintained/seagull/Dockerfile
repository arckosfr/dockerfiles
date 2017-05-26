FROM golang:1.6-alpine
MAINTAINER arckosfr <contact@lemark.xyz>

LABEL version="201608107" \
      tags="latest"

RUN apk add -U git \
    && go get github.com/astaxie/beego \
    && go get github.com/tobegit3hub/seagull
	
WORKDIR /go/src/github.com/tobegit3hub/seagull/

RUN go build seagull.go

# Expose the port
EXPOSE 10086

# Run the server
CMD ["./seagull"]