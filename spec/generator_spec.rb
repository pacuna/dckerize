require 'spec_helper'

describe Dckerize::Generator do
  let (:generator) {
    Dckerize::Generator.new('myapp', 'pgsql')
  }

  let (:generator_without_db) {
    Dckerize::Generator.new('myapp')
  }

  def clean_files
    FileUtils.rm_rf('vagrant')
    FileUtils.rm_rf('conf')
    File.delete('Dockerfile')
    File.delete('docker-compose.yml')
  end

  describe '#initialize' do
    it 'should be initialized with a name' do
      expect(generator_without_db.name).to eq 'myapp'
    end

    it 'should be initialized with a default db if not given' do
      expect(generator_without_db.db).to eq 'mysql'
    end

    it 'should be possible to initialize it with a name and a db' do
      expect([generator.name, generator.db]).to match_array(['myapp', 'pgsql'])
    end
  end

  describe '#up' do

    before(:each) do
      generator.up
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

    it 'should generate a Vagrantfile' do
      expect(File).to exist('vagrant/Vagrantfile')
    end

    it 'should generate a docker-compose installer' do
      expect(File).to exist('vagrant/docker-compose-installer.sh')
    end

    it 'should generate a Dockerfile' do
      expect(File).to exist('Dockerfile')
    end

    it 'should generate a site config for nginx' do
      expect(File).to exist("conf/#{generator.name}.conf")
    end

    it 'should generate an env config for nginx' do
      expect(File).to exist("conf/env.conf")
    end

    it 'should generate a docker-compose file' do
      expect(File).to exist("docker-compose.yml")
    end
  end


end
