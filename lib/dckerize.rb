require "dckerize/version"
require 'erb'
require 'fileutils'

module Dckerize
  def self.root
    File.dirname __dir__
  end

  def self.templates
    File.join root, 'templates'
  end

  class Generator
    attr_accessor :name, :db
    def initialize(name, db = 'mysql')
      @name = name
      @db   = db
    end

    def get_binding
      binding
    end

    def templates
      Dckerize.templates
    end

    def up
      FileUtils.mkdir_p('conf')
      FileUtils.mkdir_p('vagrant')

      create_from_template('Vagrantfile.erb', 'vagrant/Vagrantfile')
      create_from_template('Dockerfile.erb', 'Dockerfile')
      create_from_template('site.conf.erb', "conf/#{@name}.conf")
      create_from_template('env.conf.erb', "conf/env.conf")
      create_from_template('docker-compose.yml.erb', "docker-compose.yml")
      create_from_template('docker-compose-installer.sh.erb', "vagrant/docker-compose-installer.sh")
    end

    private
    def create_from_template(template_name, output_file)
      template = ERB.new(File.read("#{templates}/#{template_name}"))
      result = template.result(binding)
      File.open("#{output_file}", 'w') { |file| file.write(result) }
    end

  end
end
