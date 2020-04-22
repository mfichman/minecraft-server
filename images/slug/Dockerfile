# Asset precompilation
FROM ruby:2.6 AS slug
ENV RAILS_ENV=production
WORKDIR /minecraft

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential nodejs yarn
RUN gem install bundler

ADD https://raw.githubusercontent.com/mfichman/minecraft-server/master/Gemfile /minecraft/Gemfile
RUN bundle

ADD https://raw.githubusercontent.com/mfichman/minecraft-server/master/package.json /minecraft/package.json
ADD https://raw.githubusercontent.com/mfichman/minecraft-server/master/yarn.lock /minecraft/yarn.lock
RUN yarn install --modules-folder=/usr/local/node_modules

RUN rm -r /minecraft
RUN git clone --depth 1 https://github.com/mfichman/minecraft-server.git /minecraft
RUN ln -sn /usr/local/node_modules /minecraft/node_modules
RUN SECRET_KEY_BASE=`rails secret` rails assets:precompile

# Final application image
FROM ruby:2.6
MAINTAINER Matt Fichman <matt.fichman@gmail.com>

COPY --from=slug /usr/local/bundle /usr/local/bundle
COPY --from=slug /minecraft/public/assets /assets
COPY --from=slug /minecraft/public/packs /packs

VOLUME /data

ENV RAILS_ENV=production

#RUN git clone --depth 1 https://github.com/mfichman/minecraft-server.git /minecraft
RUN VERSION=3 git clone --depth 1 git://git/ /minecraft
RUN ln -sn /assets /minecraft/public/assets
RUN ln -sn /packs /minecraft/public/packs
RUN ln -sn /data /minecraft/db/

WORKDIR /minecraft

EXPOSE 3001
CMD rails db:setup && rails server -p 3001 -b 0.0.0.0
