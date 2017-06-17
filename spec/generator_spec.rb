require 'spec_helper'
describe Dckerize::Generator do
  let (:generator) {
    Dckerize::Generator.new('myapp')
  }

  describe '#initialize' do
    it 'should be possible to initialize it with a name and a db' do
      expect(generator.name).to eq('myapp')
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
        expect{ generator.up }.to raise_error Dckerize::Runner::DOCKERFILE_EXISTS
      end
    end

    describe 'docker-compose already exists' do
      before(:each) do
        FileUtils.touch('docker-compose.yml')
      end

      after(:each) do
        clean_files
      end

      it 'should not create the docker-compose file and give notification' do
        expect{ generator.up }.to raise_error Dckerize::Runner::DOCKERCOMPOSE_EXISTS
      end
    end
  end


  context 'generator with postgres' do
    describe '#up' do

      before(:each) do
        generator.up
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
end
