# Base system dependencies --------------------------------------------------------------
FROM alpine:3.11 as base
MAINTAINER Matt Fichman <matt.fichman@gmail.com>
WORKDIR /bundle

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV BUNDLE_PATH=/bundle/vendor/bundle
ENV BUNDLE_WITHOUT=test:development
ENV BUNDLE_SILENCE_ROOT_WARNING=true

RUN apk add ruby sqlite-libs libxml2 libxslt libstdc++ openssl
RUN gem install bundler:2.1.4

# Builder/asset precompilation ----------------------------------------------------------
FROM base as builder

RUN apk add ruby-dev sqlite-dev libxml2-dev libxslt-dev nodejs-dev yarn build-base openssl-dev

COPY Gemfile Gemfile.lock /bundle/
RUN bundle install

COPY package.json yarn.lock /bundle/
RUN yarn install --production=true

COPY . /bundle
RUN SECRET_KEY_BASE=`bin/rails secret` bin/rails assets:precompile webpacker:compile
RUN rm -rf /bundle/node_modules

# Production image ----------------------------------------------------------------------
FROM base

COPY --from=builder /bundle /bundle

VOLUME /bundle/db
VOLUME /bundle/data

EXPOSE 80 443

CMD sh
