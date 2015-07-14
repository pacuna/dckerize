require 'spec_helper' 
describe Dckerize::Generator do
  let (:generator_with_postgres) {
    Dckerize::Generator.new('myapp', 'postgres')
  }

  let (:generator_with_mysql) {
    Dckerize::Generator.new('myapp', 'mysql')
  }

  let (:generator_with_one_extra) {
    Dckerize::Generator.new('myapp', 'postgres', ['elasticsearch'])
  }

  let (:generator_with_several_extras) {
    Dckerize::Generator.new('myapp', 'postgres', ['elasticsearch', 'redis', 'memcached'])
  }

  let (:generator_with_mongo) {
    Dckerize::Generator.new('myapp', 'mongo')
  }

  describe '#initialize' do
    it 'should be possible to initialize it with a name and a db' do
      expect([generator_with_postgres.name, generator_with_postgres.db]).to match_array(['myapp', 'postgres'])
    end
  end

  context 'generator with mongo' do
    describe '#up' do

      before(:each) do
        generator_with_mongo.up
      end

      after(:each) do
        clean_files
      end

      it 'should generate a vagrant directory' do
        expect(File.directory?('vagrant')).to eq true
      end

      it 'should generate a conf directory' do
        expect(File.directory?('conf')).to eq true
      end

      context 'describing Vagrantfile' do
        it 'should generate a Vagrantfile' do
          expect(File).to exist('vagrant/Vagrantfile')
        end

        it 'should contain a synced_folder with the project name' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'config.vm.synced_folder "../", "/myapp"'
          )
        end

        it 'should pull the latest nginx passenger container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "phusion/passenger-ruby22:0.9.15"'
          )
        end

        it 'should pull the mongodb container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "mongo"'
          )
        end
      end

      it 'should generate a docker-compose installer' do
        expect(File).to exist('vagrant/docker-compose-installer.sh')
      end

      it 'should generate a Dockerfile' do
        expect(File).to exist('Dockerfile')
      end

      it 'should generate a site config for nginx' do
        expect(File).to exist("conf/#{generator_with_mongo.name}.conf")
      end

      context 'describing env file' do

        it 'should generate an entry for the dbhost' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env MONGO_PORT_27017_TCP_ADDR;'
          )
        end
      end

      context 'describin docker-compose.yml file' do
        it 'should generate a data image for mysql' do
          expect(File.read('docker-compose.yml'))
            .to include('image: mongo')
        end

        it 'should generate a service named mysql' do
          expect(File.read('docker-compose.yml'))
            .to include('mongo:')
        end

        it 'should generate a link between the application and a mysql container' do
          expect(File.read('docker-compose.yml'))
            .to include("mongo:mongo")
        end

        it 'should generate a correct service for data-only container' do
          expect(File.read('docker-compose.yml'))
            .to include("- /data/db")
        end
      end

      it 'should generate a docker-compose file' do
        expect(File).to exist("docker-compose.yml")
      end
    end
  end


  context 'generator with mysql' do
    describe '#up' do

      before(:each) do
        generator_with_mysql.up
      end

      after(:each) do
        clean_files
      end

      it 'should generate a vagrant directory' do
        expect(File.directory?('vagrant')).to eq true
      end

      it 'should generate a conf directory' do
        expect(File.directory?('conf')).to eq true
      end

      context 'describing Vagrantfile' do
        it 'should generate a Vagrantfile' do
          expect(File).to exist('vagrant/Vagrantfile')
        end

        it 'should contain a synced_folder with the project name' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'config.vm.synced_folder "../", "/myapp"'
          )
        end

        it 'should pull the latest nginx passenger container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "phusion/passenger-ruby22:0.9.15"'
          )
        end

        it 'should pull the mysql container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "mysql:5.7"'
          )
        end
      end

      it 'should generate a docker-compose installer' do
        expect(File).to exist('vagrant/docker-compose-installer.sh')
      end

      it 'should generate a Dockerfile' do
        expect(File).to exist('Dockerfile')
      end

      it 'should generate a site config for nginx' do
        expect(File).to exist("conf/#{generator_with_mysql.name}.conf")
      end

      context 'describing env file' do
        it 'should generate an entry for the password' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env MYSQL_ENV_MYSQL_ROOT_PASSWORD;'
          )
        end

        it 'should generate an entry for the dbhost' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env MYSQL_PORT_3306_TCP_ADDR;'
          )
        end
      end

      context 'describin docker-compose.yml file' do
        it 'should generate a data image for mysql' do
          expect(File.read('docker-compose.yml'))
            .to include('image: mysql:5.7')
        end

        it 'should generate a service named mysql' do
          expect(File.read('docker-compose.yml'))
            .to include('mysql:')
        end

        it 'should generate a link between the application and a mysql container' do
          expect(File.read('docker-compose.yml'))
            .to include("mysql:mysql")
        end

        it 'should generate a db password entry environment' do
          expect(File.read('docker-compose.yml'))
            .to include("MYSQL_ROOT_PASSWORD=secretpassword")
        end

        it 'should generate a correct service for data-only container' do
          expect(File.read('docker-compose.yml'))
            .to include("- /var/lib/mysql")
        end
      end

      it 'should generate a docker-compose file' do
        expect(File).to exist("docker-compose.yml")
      end
    end
  end

  context 'generator with postgres' do
    describe '#up' do

      before(:each) do
        generator_with_postgres.up
      end

      after(:each) do
        clean_files
      end

      it 'should generate a vagrant directory' do
        expect(File.directory?('vagrant')).to eq true
      end

      it 'should generate a conf directory' do
        expect(File.directory?('conf')).to eq true
      end

      context 'describing Vagrantfile' do
        it 'should generate a Vagrantfile' do
          expect(File).to exist('vagrant/Vagrantfile')
        end

        it 'should contain a synced_folder with the project name' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'config.vm.synced_folder "../", "/myapp"'
          )
        end

        it 'should pull the latest nginx passenger container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "phusion/passenger-ruby22:0.9.15"'
          )
        end

        it 'should pull the mysql container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "postgres"'
          )
        end
      end

      it 'should generate a docker-compose installer' do
        expect(File).to exist('vagrant/docker-compose-installer.sh')
      end

      it 'should generate a Dockerfile' do
        expect(File).to exist('Dockerfile')
      end

      it 'should generate a site config for nginx' do
        expect(File).to exist("conf/#{generator_with_postgres.name}.conf")
      end

      context 'describing env file' do
        it 'should generate an entry for the password' do
          expect(File.read('conf/env.conf'))
            .to include('env POSTGRES_ENV_POSTGRES_PASSWORD;')
        end

        it 'should generate an entry for the dbhost' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env POSTGRES_PORT_5432_TCP_ADDR;'
          )
        end
      end

      context 'describin docker-compose.yml file' do
        it 'should generate a data image for postgres' do
          expect(File.read('docker-compose.yml'))
            .to include('image: postgres')
        end

        it 'should generate a service named postgres' do
          expect(File.read('docker-compose.yml'))
            .to include('postgres:')
        end

        it 'should generate a link between the application and a postgres container' do
          expect(File.read('docker-compose.yml'))
            .to include("postgres:postgres")
        end

        it 'should generate a db password entry environment' do
          expect(File.read('docker-compose.yml'))
            .to include("POSTGRES_PASSWORD=secretpassword")
        end

        it 'should generate a correct service for data-only container' do
          expect(File.read('docker-compose.yml'))
            .to include("- /var/lib/postgresql")
        end
      end

      it 'should generate a docker-compose file' do
        expect(File).to exist("docker-compose.yml")
      end
    end
  end

  context 'generator with one extra' do
    describe '#up' do

      before(:each) do
        generator_with_one_extra.up
      end

      after(:each) do
         clean_files
      end

      it 'should generate a vagrant directory' do
        expect(File.directory?('vagrant')).to eq true
      end

      it 'should generate a conf directory' do
        expect(File.directory?('conf')).to eq true
      end

      context 'describing Vagrantfile' do
        it 'should generate a Vagrantfile' do
          expect(File).to exist('vagrant/Vagrantfile')
        end

        it 'should contain a synced_folder with the project name' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'config.vm.synced_folder "../", "/myapp"'
          )
        end

        it 'should pull the latest nginx passenger container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "phusion/passenger-ruby22:0.9.15"'
          )
        end

        it 'should pull the mysql container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "postgres"'
          )
        end

        it 'should pull the elasticsearch container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "elasticsearch"'
          )
        end
      end

      it 'should generate a docker-compose installer' do
        expect(File).to exist('vagrant/docker-compose-installer.sh')
      end

      it 'should generate a Dockerfile' do
        expect(File).to exist('Dockerfile')
      end

      it 'should generate a site config for nginx' do
        expect(File).to exist("conf/#{generator_with_one_extra.name}.conf")
      end

      context 'describing env file' do
        it 'should generate an entry for the password' do
          expect(File.read('conf/env.conf'))
            .to include('env POSTGRES_ENV_POSTGRES_PASSWORD;')
        end

        it 'should generate an entry for the dbhost' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env POSTGRES_PORT_5432_TCP_ADDR;'
          )
        end

        it 'should generate an entry for the elasticsearch host' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env ELASTICSEARCH_PORT_9200_TCP_ADDR;'
          )
        end

        it 'should generate an entry for the elasticsearch host' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env ELASTICSEARCH_URL;'
          )
        end
      end

      context 'describin docker-compose.yml file' do
        it 'should generate a data image for postgres' do
          expect(File.read('docker-compose.yml'))
            .to include('image: postgres')
        end

        it 'should generate a service named postgres' do
          expect(File.read('docker-compose.yml'))
            .to include('postgres:')
        end

        it 'should generate a service named elasticsearch' do
          expect(File.read('docker-compose.yml'))
            .to include('elasticsearch:')
        end

        it 'should generate a link between the application and a postgres container' do
          expect(File.read('docker-compose.yml'))
            .to include("postgres:postgres")
        end

        it 'should generate a link between the application and the elasticsearch container' do
          expect(File.read('docker-compose.yml'))
            .to include("elasticsearch:elasticsearch")
        end

        it 'should generate a db password entry environment' do
          expect(File.read('docker-compose.yml'))
            .to include("POSTGRES_PASSWORD=secretpassword")
        end

        it 'should generate a correct service for data-only container' do
          expect(File.read('docker-compose.yml'))
            .to include("- /var/lib/postgresql")
        end
      end

      it 'should generate a docker-compose file' do
        expect(File).to exist("docker-compose.yml")
      end
    end
  end

  context 'generator with several extras' do
    describe '#up' do

      before(:each) do
        generator_with_several_extras.up
      end

      after(:each) do
         clean_files
      end

      it 'should generate a vagrant directory' do
        expect(File.directory?('vagrant')).to eq true
      end

      it 'should generate a conf directory' do
        expect(File.directory?('conf')).to eq true
      end

      context 'describing Vagrantfile' do
        it 'should generate a Vagrantfile' do
          expect(File).to exist('vagrant/Vagrantfile')
        end

        it 'should contain a synced_folder with the project name' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'config.vm.synced_folder "../", "/myapp"'
          )
        end

        it 'should pull the latest nginx passenger container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "phusion/passenger-ruby22:0.9.15"'
          )
        end

        it 'should pull the mysql container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "postgres"'
          )
        end

        it 'should pull the elasticsearch container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "elasticsearch"'
          )
        end

        it 'should pull the redis container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "redis"'
          )
        end

        it 'should pull the memcached container' do
          expect(File.read('vagrant/Vagrantfile'))
            .to include(
          'd.pull_images "memcached"'
          )
        end
      end

      it 'should generate a docker-compose installer' do
        expect(File).to exist('vagrant/docker-compose-installer.sh')
      end

      it 'should generate a Dockerfile' do
        expect(File).to exist('Dockerfile')
      end

      it 'should generate a site config for nginx' do
        expect(File).to exist("conf/#{generator_with_several_extras.name}.conf")
      end

      context 'describing env file' do
        it 'should generate an entry for the password' do
          expect(File.read('conf/env.conf'))
            .to include('env POSTGRES_ENV_POSTGRES_PASSWORD;')
        end

        it 'should generate an entry for the dbhost' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env POSTGRES_PORT_5432_TCP_ADDR;'
          )
        end

        it 'should generate an entry for the elasticsearch host' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env ELASTICSEARCH_PORT_9200_TCP_ADDR;'
          )
        end

        it 'should generate an entry for the elasticsearch host' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env ELASTICSEARCH_URL;'
          )
        end

        it 'should generate an entry for the redis host' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env REDIS_PORT_6379_TCP_ADDR;'
          )
        end

        it 'should generate an entry for the memcached host' do
          expect(File.read('conf/env.conf'))
            .to include(
          'env MEMCACHED_PORT_11211_TCP_ADDR;'
          )
        end
      end

      context 'describin docker-compose.yml file' do
        it 'should generate a data image for postgres' do
          expect(File.read('docker-compose.yml'))
            .to include('image: postgres')
        end

        it 'should generate a service named postgres' do
          expect(File.read('docker-compose.yml'))
            .to include('postgres:')
        end

        it 'should generate a service named elasticsearch' do
          expect(File.read('docker-compose.yml'))
            .to include('elasticsearch:')
        end

        it 'should generate a service named redis' do
          expect(File.read('docker-compose.yml'))
            .to include('redis:')
        end

        it 'should generate a service named memcached' do
          expect(File.read('docker-compose.yml'))
            .to include('memcached:')
        end

        it 'should generate a link between the application and a postgres container' do
          expect(File.read('docker-compose.yml'))
            .to include("postgres:postgres")
        end

        it 'should generate a link between the application and the elasticsearch container' do
          expect(File.read('docker-compose.yml'))
            .to include("elasticsearch:elasticsearch")
        end

        it 'should generate a link between the application and the redis container' do
          expect(File.read('docker-compose.yml'))
            .to include("redis:redis")
        end

        it 'should generate a link between the application and the memcached container' do
          expect(File.read('docker-compose.yml'))
            .to include("memcached:memcached")
        end

        it 'should generate a db password entry environment' do
          expect(File.read('docker-compose.yml'))
            .to include("POSTGRES_PASSWORD=secretpassword")
        end

        it 'should generate a correct service for data-only container' do
          expect(File.read('docker-compose.yml'))
            .to include("- /var/lib/postgresql")
        end
      end

      it 'should generate a docker-compose file' do
        expect(File).to exist("docker-compose.yml")
      end
    end
  end
end
