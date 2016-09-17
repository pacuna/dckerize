$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dckerize'

def clean_files
  FileUtils.rm_f('Dockerfile.development')
  FileUtils.rm_f('docker-compose.yml')
  FileUtils.rm_f('setup.sh')
  FileUtils.rm_f('webapp.conf')
  FileUtils.rm_f('rails-env.conf')
end
