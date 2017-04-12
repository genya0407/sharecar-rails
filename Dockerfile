FROM ruby:2.4-alpine

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev sqlite-dev postgresql-dev mysql-dev" \
    RUBY_PACKAGES="nodejs postgresql-client"

RUN apk --update --upgrade add $BUILD_PACKAGES $RUBY_PACKAGES $DEV_PACKAGES

ADD Gemfile /tmp
ADD Gemfile.lock /tmp
WORKDIR /tmp
RUN bundle install

WORKDIR /app
CMD bundle exec rails server -b 0.0.0.0
