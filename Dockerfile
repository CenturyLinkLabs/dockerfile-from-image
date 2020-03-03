FROM alpine:3.5
MAINTAINER CenturyLink Labs <clt-labs-futuretech@centurylink.com>

RUN apk --update add ruby-dev ruby make gcc libc-dev ca-certificates && \
    gem install --no-rdoc --no-ri docker-api && \
    apk del ruby-dev ca-certificates make gcc libc-dev && \
    apk add ruby-json && \
    rm /var/cache/apk/*

ADD dockerfile-from-image.rb /usr/src/app/dockerfile-from-image.rb

ENTRYPOINT ["/usr/src/app/dockerfile-from-image.rb"]
CMD ["--help"]
