FROM centurylinklabs/ruby-base:2.1.2

ADD . /usr/src/app
WORKDIR /usr/src/app
RUN gem install docker-api

CMD [""]
ENTRYPOINT ["/usr/src/app/dockerfile-from-image.rb"]
