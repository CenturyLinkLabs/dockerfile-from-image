FROM alpine:3.2
MAINTAINER CenturyLink Labs <clt-labs-futuretech@centurylink.com>

RUN apk --update add ruby-dev ca-certificates && \
    gem install --no-rdoc --no-ri docker-api && \
    apk del ruby-dev ca-certificates && \
    apk add ruby ruby-json && \
    rm /var/cache/apk/*

ADD dockerfile-from-image.rb /usr/src/app/dockerfile-from-image.rb

ENTRYPOINT ["/usr/src/app/dockerfile-from-image.rb"]
CMD ["--help"]
