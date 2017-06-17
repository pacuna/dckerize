module Dckerize
  class Generator
    attr_accessor :name
    def initialize(name)
      @name = name
    end

    def get_binding
      binding
    end

    def templates
      Dckerize.templates
    end

    def up

      raise Dckerize::Runner::DOCKERFILE_EXISTS if File.exists?('Dockerfile.development')
      raise Dckerize::Runner::DOCKERCOMPOSE_EXISTS if File.exists?('docker-compose.yml')

      create_from_template('Dockerfile.erb', 'Dockerfile.development')
      create_from_template('webapp.conf.erb', "webapp.conf")
      create_from_template('wait-for-postgres.sh.erb', "wait-for-postgres.sh")
      create_from_template('rails-env.conf.erb', "rails-env.conf")
      create_from_template('docker-compose.yml.erb', "docker-compose.yml")
    end

    private
    def create_from_template(template_name, output_file)
      template = ERB.new(File.read("#{templates}/#{template_name}"), nil, '-')
      result = template.result(binding)
      File.open("#{output_file}", 'w') { |file| file.write(result) }

      # add execution permissions for setup.sh
      system "chmod +x #{output_file}" if output_file == 'wait-for-postgres.sh'
    end

  end

end
