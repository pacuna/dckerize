module Dckerize
  class Extra
    attr_accessor :name
    def initialize(name)
      @name = name
    end

    def image
      if name == 'elasticsearch'
        'elasticsearch'
      end
    end

    def service_name
      if name == 'elasticsearch'
        'elasticsearch'
      end
    end

    def alias
      if name == 'elasticsearch'
        'elasticsearch'
      end
    end

    def env_variables
      if name == 'elasticsearch'
        ['ELASTICSEARCH_PORT_9200_TCP_ADDR', 'ELASTICSEARCH_URL']
      end
    end
  end

end
