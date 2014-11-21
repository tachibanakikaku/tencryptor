require 'logger'

require_relative 'tencryptor/version'
require_relative 'tencryptor/encrypter'
require_relative 'tencryptor/sha256_encrypter'

module Tencryptor
  class << self
    attr_accessor :configuration, :logger
  end

  def self.debug(data)
    self.logger ||= ::Logger.new(STDOUT)
    self.logger.debug data
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

  class Configuration
    attr_accessor :version, :algorithm, :headers,
      :access_key, :secret_access_key, :service, :region, :debug
  end
end
