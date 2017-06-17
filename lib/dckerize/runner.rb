module Dckerize
  class Runner

    ERROR_MESSAGE         = 'USAGE: dckerize up APP_NAME'
    CONF_FOLDER_EXISTS    = 'ERROR: conf folder already exists.'
    DOCKERFILE_EXISTS     = 'ERROR: Dockerfile.development already exists.'
    DOCKERCOMPOSE_EXISTS  = 'ERROR: docker-compose already exists.'
    def initialize(options)
      @options = options
    end

    def execute
      raise ERROR_MESSAGE unless valid?
      Dckerize::Generator.new(@options[1]).up
    end

    def valid?
      # first option should always be up
      return false if @options[0] != 'up'
      true
    end
  end

end
