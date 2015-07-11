FROM phusion/passenger-ruby22:0.9.15

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Active nginx
RUN rm -f /etc/service/nginx/down

# Copy the nginx template for configuration and preserve environment variables
RUN rm /etc/nginx/sites-enabled/default
ADD conf/myapp.conf /etc/nginx/sites-enabled/myapp.conf
ADD conf/env.conf /etc/nginx/main.d/env.conf

# Create the folder for the project and set the workdir
RUN mkdir /home/app/myapp
WORKDIR /home/app/myapp

# Copy the project inside the container and run bundle install
COPY Gemfile /home/app/myapp/
COPY Gemfile.lock /home/app/myapp/
RUN bundle install
COPY . /home/app/myapp

# Set permissions for the passenger user for this app
RUN chown -R app:app /home/app/myapp

# Expose the port
EXPOSE 80
