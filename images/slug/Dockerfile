# Asset precompilation
FROM ruby:2.6 AS slug
ENV RAILS_ENV=production
WORKDIR /minecraft

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential nodejs yarn
RUN gem install bundler

ADD https://raw.githubusercontent.com/mfichman/minecraft-server/master/Gemfile /minecraft/Gemfile
RUN bundle

ADD https://raw.githubusercontent.com/mfichman/minecraft-server/master/package.json /minecraft/package.json
RUN yarn

RUN mv /minecraft/ /minecraft-tmp/
RUN git clone --depth 1 https://github.com/mfichman/minecraft-server.git /minecraft
RUN mv -f /minecraft-tmp/* /minecraft/
RUN rails assets:precompile

# Final application image
FROM ruby:2.6
MAINTAINER Matt Fichman <matt.fichman@gmail.com>

COPY --from=slug /minecraft/public/assets /minecraft/public/assets
COPY --from=slug /usr/local/bundle /usr/local/bundle
RUN git clone --depth 1 https://github.com/mfichman/minecraft-server.git /minecraft

EXPOSE 80
CMD bin/rails server -p 80
