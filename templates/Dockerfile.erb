FROM phusion/passenger-ruby25:1.0.1

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Additional packages
RUN apt-get update && apt-get install -y -o Dpkg::Options::="--force-confold" postgresql-client tzdata

# Enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install gems: it's better to build an independent layer for the gems
# so they are cached during builds unless Gemfile changes
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install --jobs 4 --retry 3

# Add virtual host entry for the application
RUN rm /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf

# In case we need some environmental variables in Nginx
ADD rails-env.conf /etc/nginx/main.d/rails-env.conf

# Copy application into the container and use right permissions: passenger
# uses the app user for running the application
RUN mkdir /home/app/webapp
COPY --chown=app:app . /home/app/webapp
WORKDIR /home/app/webapp

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
