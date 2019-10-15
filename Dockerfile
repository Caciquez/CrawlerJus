FROM elixir:1.9

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y \
  sudo

RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
  apt-get install -y \
  inotify-tools \
  postgresql-client-9.6 \
  nodejs \
  yarn

RUN mix local.hex --force && mix local.rebar --force

RUN mix archive.install hex phx_new 1.4.9 --force

WORKDIR /app

RUN cd app/assets && yarn install