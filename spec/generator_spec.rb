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


  describe '#initialize' do
    it 'should be possible to initialize it with a name and a db' do
      expect([generator_with_postgres.name, generator_with_postgres.db]).to match_array(['myapp', 'postgres:9.5.3'])
    end
  end

  context 'file already present' do


    describe 'Dockerfile.development already exitst' do
      before(:each) do
        FileUtils.touch('Dockerfile.development')
      end

      after(:each) do
        clean_files
      end

      it 'should not create the Dockerfile.development and give notification' do
        expect{ generator_with_postgres.up }.to raise_error Dckerize::Runner::DOCKERFILE_EXISTS
      end
    end

    describe 'docker-compose already exitst' do
      before(:each) do
        FileUtils.touch('docker-compose.yml')
      end

      after(:each) do
        clean_files
      end

      it 'should not create the docker-compose file and give notification' do
        expect{ generator_with_postgres.up }.to raise_error Dckerize::Runner::DOCKERCOMPOSE_EXISTS
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

      it 'should generate a Dockerfile.development' do
        expect(File).to exist('Dockerfile.development')
      end

      it 'should generate a site config for nginx' do
        expect(File).to exist("webapp.conf")
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

        it 'should generate a db password entry environment' do
          expect(File.read('docker-compose.yml'))
            .to include("MYSQL_ROOT_PASSWORD=mysecretpassword")
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

      it 'should generate a Dockerfile.development' do
        expect(File).to exist('Dockerfile.development')
      end

      it 'should generate a site config for nginx' do
        expect(File).to exist("webapp.conf")
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

        it 'should generate a db password entry environment' do
          expect(File.read('docker-compose.yml'))
            .to include("POSTGRES_PASSWORD=mysecretpassword")
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

      it 'should generate a Dockerfile.development' do
        expect(File).to exist('Dockerfile.development')
      end

      it 'should generate a site config for nginx' do
        expect(File).to exist("webapp.conf")
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


        it 'should generate a db password entry environment' do
          expect(File.read('docker-compose.yml'))
            .to include("POSTGRES_PASSWORD=mysecretpassword")
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

      it 'should generate a Dockerfile.development' do
        expect(File).to exist('Dockerfile.development')
      end

      it 'should generate a site config for nginx' do
        expect(File).to exist("webapp.conf")
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

        it 'should generate a db password entry environment' do
          expect(File.read('docker-compose.yml'))
            .to include("POSTGRES_PASSWORD=mysecretpassword")
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
