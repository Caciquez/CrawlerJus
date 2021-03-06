# CrawlerJus

> Created using: Elixir, Phoenix Framework, Erlang, Postgres, Redis, Docker

> Clone the project
  `https://github.com/Caciquez/CrawlerJus.git`

# Requirements Docker development

- `Docker version 19.03.2`
- `Docker-compose version 1.24.1`

1. Run the following command to build the application on docker-compose:

```bash
docker-compose up --build
```

2. Run the following command to execute the tests on docker enviroment

> Backend
```bash
docker-compose run web mix test
``` 
> Frontend
```bash
docker-compose run web bash -c "cd assets/ && yarn test"
``` 

# Requirements Native development

- `Elixir 1.9`
- `Erlang 22.0`
- `PostgreSQL 11.5`
- `Redis-cli 5.0.5`

## 1. Installing Elixir and Erlang:

  Enter project folder: ``cd crawler_jus`` then follow the steps.

> Mac OS X:

  * Update your homebrew to latest: brew update
  * Run: ``brew install elixir``

> Unix (and Unix-like):

  * Ubuntu 14.04/16.04/16.10/17.04 or Debian 7/8/9

  * Add Erlang Solutions repo: wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
  * Run: ``sudo apt-get update``
  * Install the Erlang/OTP platform and all of its applications: ``sudo apt-get install esl-erlang``
  * Install Elixir: ``sudo apt-get install elixir``

> asdf
  * Follow this link [Setup Tutorial](https://github.com/asdf-vm/asdf#setup).
  * then run 
  ``
  asdf install
  ``

## 2. Install Postgres:

The database I use in the project is PostgreSQL, so you need to install it to make it work.

> Mac OS X:

* ``brew install postgresql``

> Linux (Ubuntu):

* ``sudo apt-get install postgresql``

# Configure PostgreSQL

> Open terminal and execute the following scripts

* ``psql postgres``

> And then run the command:

* ``CREATE USER postgres WITH PASSWORD 'postgres';``

## 3. Install Redis

> Mac OS X:

* ``brew install redis``
* ``brew services start redis``

> Linux (Ubuntu):

```bash
> sudo apt update
> sudo apt install redis
> sudo systemctl start redis-server
```

## 3. Install Hex Manager Package & Phoenix Framework

  * ``mix local.hex``
  * ``mix archive.install hex phx_new 1.4.9``

## 4. Install dependencies


To install all dependecies and configure your app follow:

  * Duplicate both `dev` and `test` configuration files from `config/db`.

  ```
  cp config/db/dev.secret.exs.example config/db/dev.secret.exs
  cp config/db/test.secret.exs.example config/db/test.secret.exs
  ```

  * Configure property with your credentials
  * Install dependencies with `mix deps.get`

  ```
  mix deps.get
  ```

  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`

  ```
  mix ecto.setup
  ```

  * Install Node.js (with nvm: https://github.com/creationix/Nvm#install-script) or run asdf install
  * Install yarn

  ```
  npm install -g yarn
  ```

  * Install Node.js dependencies with `cd assets && yarn install`

  ```
  cd assets && yarn install
  ````

  * Start Phoenix endpoint and run application

  ```
  mix phx.server
  ```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Running Tests

  * To run javascript tests:

  ```
  cd assets
  yarn test
  ```

  * To run Elixir tests with native elixir:

  ```
  mix test
  ```



