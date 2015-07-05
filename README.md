# Dckerize

Supercharged Rails development using Docker and Vagrant

## Description

This gem gives you a good starting point for developing your Rails application using container managed by Docker
inside of a VM manage by Vagrant.

You'll get;

- An ubuntu trusty image already provisioned with Docker and Docker compose.
- An nginx+passenger container environment for serving your application and all the neccesary configuration.
- A separated container running MySQL for your DB.
- A separated container for persisting your data using the data-only container pattern.


## Requirements

- ruby and bundler
- vagrant >= 1.6

## Installation

    $ gem install dckerize

## Usage

You need to have a Rails application already created.
Then, in the root of your application run:

    $ dckerize up APP_NAME

Where APP_NAME should be the same name of our application directory.

### Generated Structure

Dckerize will generate:

- A Vagrant folder, which contains a Vagrantfile and a docker-compose bash script for provisioning.
- A conf folder containing an nginx configuration for your site and an environment definition file for passing
the neccessary environment variables to passenger. Any extra environment variables passed to your rails application
should be declared in this file.
- A Dockerfile for building your application.
- A docker-compose.yml file for lifting your entire enviroment

### DB configuration

Righ now only MySQL is supported.
In your config/database.yml add this lines to your configuration:

    username: root
    password: <%= ENV['MYSQL_ENV_MYSQL_ROOT_PASSWORD'] %>
    host: mysql

You can set the password for development in the docker-compose.yml file.
The host can be setted to mysql since the container is being linked to the mysql container
using this alias (docker created an entry in the /etc/hosts using this hostname associated to the real container ip)

### Developing

Go inside the generated vagrant folder and run

    $ vagrant up

Vagrant will pull the ubuntu trusty image, the neccesary docker images and set the shared folder for
development.

Once finished, run:

    $ vagrant ssh
    $ cd /APP_NAME
    $ docker-compose up -d

Since the folder is being shared with the virtual machine, you can run docker-compose using the docker-compose.yml file.
This will build the container for your application, the db and the neccessary links for the containers.

The application folder will also be mounted inside the container, so you can work as you normally do locally and see the changes
reflected inmediatly in the container.

Now you go inside the container and run the typical rails commands for interacting with your application.
For getting the app container name run:

    $ docker ps

This will show you the running container. Choose the one that's running your app and go inside by running:

    $ docker exec -it CONTAINER_NAME bash

Now you can interact with your application

    $ rake db:create
    $ rake db:migrate
    $ rails c

And etc.

The nginx container is mapping its port 80 with the port 80 of the guest host, and since we're declaring a private network in our Vagranfile
you can access your application by visiting htt://192.168.50.4.

## Contributing

1. Fork it ( https://github.com/pacuna/dckerize/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
