# Dckerize
[![Gem Version](https://badge.fury.io/rb/dckerize.svg)](http://badge.fury.io/rb/dckerize)
[![Build Status](https://travis-ci.org/pacuna/dckerize.svg?branch=master)](https://travis-ci.org/pacuna/dckerize)

Supercharged Rails development using Docker

## Description

This gem gives you a good starting point to containerize your Rails 5 applications using Docker.

You'll get

- An nginx/passenger container environment for your application and all the necessary configurations. It also mounts the application into the container so you can make development changes and not having to rebuild the image.
- A separate container running PostgreSQL
- A separate container for keeping your data using the data-only container pattern.

## Requirements

- Docker >= 1.13
- Docker Compose >= 1.13

## Installation

    $ gem install dckerize

## Usage

### Quickstart

    $ rails new myapp --database=postgresql
    $ cd myapp
    $ dckerize up myapp

Configure your database credentials (you can check these in your docker compose file):

    username: myapp
    password: mysecretpassword
    host: myapp-db

Dckerize will use the name of your application to create the database host and user names.
It also will create the development database by default (myapp_development in this case).

Once you have your database configured, you can run:

```
$ docker-compose build
$ docker-compose up
```

And that's it. Now you can go to localhost and see your dockerized Rails application.

## Contributing

1. Fork it ( https://github.com/pacuna/dckerize/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
