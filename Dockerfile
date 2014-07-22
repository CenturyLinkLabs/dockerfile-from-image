FROM centurylinklabs/ruby-base:2.1.2

ADD dockerfile-from-image.rb /usr/src/app/dockerfile-from-image.rb
WORKDIR /usr/src/app
RUN chmod +x dockerfile-from-image.rb
RUN gem install docker-api

CMD [""]
ENTRYPOINT ["/usr/src/app/dockerfile-from-image.rb"]
