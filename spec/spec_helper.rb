$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dckerize'

def clean_files
  FileUtils.rm_rf('vagrant')
  FileUtils.rm_rf('conf')
  FileUtils.rm_f('Dockerfile')
  FileUtils.rm_f('docker-compose.yml')
end
