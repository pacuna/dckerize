module Dckerize
  class Runner

    VALID_DBS     = ['mysql', 'postgres', 'mongo']
    VALID_EXTRAS  = ['elasticsearch', 'redis', 'memcached']
    ERROR_MESSAGE = 'USAGE: dckerize up APP_NAME --database=[mysql|postgres|mongo] [--extras=elasticsearch|redis]'
    def initialize(options)
      @options = options
    end

    def execute
      extras = []
      db = ''
      raise ERROR_MESSAGE unless valid?
      @options[2..-1].each do |option|
        splitted_option = option.split('=')
        if splitted_option[0] == '--database'
          db = splitted_option[1]
        elsif splitted_option[0] == '--extras'
          extras << splitted_option[1].split(',')
        else
          raise_error ERROR_MESSAGE
        end
      end
      Dckerize::Generator.new(@options[1], db, extras.flatten).up
    end

    def valid?
      # first option should always be up
      return false if @options[0] != 'up'
      # db is mandatory
      return false unless @options.grep(/--database=/).any?

      # only valid options allowed
      # for dbs and extras
      @options[2..-1].each do |option|
        if option.split('=')[0] == '--database'
          return false unless VALID_DBS.include?(option.split('=')[1])
        elsif option.split('=')[0] == '--extras'
          (option.split('=')[1]).split(',').each do |extra|
            return false unless VALID_EXTRAS.include?(extra)
          end
        else
          return false
        end
      end
      true
    end
  end

end
