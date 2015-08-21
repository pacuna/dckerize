module Dckerize
  class Generator
    attr_accessor :name, :db, :extras
    def initialize(name, db, extras = [])
      if db == 'mysql'
        @db              = 'mysql:5.7'
        @db_password     = 'MYSQL_ROOT_PASSWORD'
        @db_password_env = 'MYSQL_ENV_MYSQL_ROOT_PASSWORD'
        @db_host_env     = 'MYSQL_PORT_3306_TCP_ADDR'
        @data_volume_dir = '/var/lib/mysql'
        @db_service_name = 'mysql'
      elsif db == 'postgres'
        @db              = 'postgres'
        @db_password     = 'POSTGRES_PASSWORD'
        @db_password_env = 'POSTGRES_ENV_POSTGRES_PASSWORD'
        @db_host_env     = 'POSTGRES_PORT_5432_TCP_ADDR'
        @data_volume_dir = '/var/lib/postgresql'
        @db_service_name = 'postgres'
      elsif db == 'mongo'
        @db              = 'mongo'
        @db_host_env     = 'MONGO_PORT_27017_TCP_ADDR'
        @data_volume_dir = '/data/db'
        @db_service_name = 'mongo'
      end
      @name = name

      @extras = Array.new
      extras.each do |extra|
        @extras << Dckerize::Extra.new(extra)
      end
    end

    def get_binding
      binding
    end

    def templates
      Dckerize.templates
    end

    def up

      # create vagrant and conf folders only if don't exist
      raise Dckerize::Runner::VAGRANT_FOLDER_EXISTS if File.exists?('vagrant') 
      raise Dckerize::Runner::CONF_FOLDER_EXISTS if File.exists?('conf')
      raise Dckerize::Runner::DOCKERFILE_EXISTS if File.exists?('Dockerfile')
      raise Dckerize::Runner::DOCKERCOMPOSE_EXISTS if File.exists?('docker-compose.yml')
      FileUtils.mkdir_p('vagrant')
      FileUtils.mkdir_p('conf')

      create_from_template('Vagrantfile.erb', 'vagrant/Vagrantfile')
      create_from_template('Dockerfile.erb', 'Dockerfile')
      create_from_template('site.conf.erb', "conf/#{@name}.conf")
      create_from_template('env.conf.erb', "conf/env.conf")
      create_from_template('docker-compose.yml.erb', "docker-compose.yml")
      create_from_template('docker-compose-installer.sh.erb', "vagrant/docker-compose-installer.sh")
    end

    private
    def create_from_template(template_name, output_file)
      template = ERB.new(File.read("#{templates}/#{template_name}"), nil, '-')
      result = template.result(binding)
      File.open("#{output_file}", 'w') { |file| file.write(result) }
    end

  end

end
