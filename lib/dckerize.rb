require "dckerize/version"
require "dckerize/extra"
require "dckerize/generator"
require "dckerize/runner"
require 'erb'
require 'fileutils'

module Dckerize
  def self.root
    File.dirname __dir__
  end

  def self.templates
    File.join root, 'templates'
  end

end
