# Dckerize
[![Gem Version](https://badge.fury.io/rb/dckerize.svg)](http://badge.fury.io/rb/dckerize)
[![Build Status](https://travis-ci.org/pacuna/dckerize.svg?branch=master)](https://travis-ci.org/pacuna/dckerize)

Supercharged Rails development using Docker

## Description

This gem gives you a good starting point to containerize your Rails 5 applications using Docker.

You'll get

- An nginx/passenger container environment for serving your application and all the necessary configurations.
- A separate container running MySQL or PostgreSQL
- A separate container for keeping your data using the data-only container pattern.
- Extras (elasticsearch, redis and memcached for now)

## Requirements

- Docker >= 1.12
- Docker Compose >= 1.8

## Installation

    $ gem install dckerize

## Usage

You need to have a Rails 5 application already created. It can be useful if you
create your app using the `--database` flag so you can have the driver already configured.

General usage:

    $ dckerize up APP_NAME --database=<mysql|postgres> [--extras=elasticsearch,redis,memcached]

So for example in the root of your application run:

    $ dckerize up APP_NAME --database=mysql

Or

    $ dckerize up APP_NAME --database=postgres

Or

    $ dckerize up APP_NAME --database=postgres --extras=elasticsearch,redis

Where APP_NAME should be the same name of your application and you must specify the database
that you want to use.

## Database Configuration

After running the `up` command you have to configure your database credentials
in the following way:

### MySQL
In your config/database.yml add these lines to your configuration:

    username: root
    password: mysecretpassword
    host: mysql

### Postgres
In your config/database.yml add these lines to your configuration:

    username: postgres
    password: mysecretpassword
    host: postgres


Once you have your database configured, you can run:

```
$ docker-compose up --build
```

## Contributing

1. Fork it ( https://github.com/pacuna/dckerize/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
