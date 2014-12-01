require 'logger'

require_relative 'tencryptor/version'
require_relative 'tencryptor/encrypter'
require_relative 'tencryptor/sha256_encrypter'

module Tencryptor
  class << self
    attr_accessor :config, :logger
  end

  def self.debug(data)
    self.logger ||= ::Logger.new(STDOUT)
    self.logger.debug data
  end

  def self.configure
    self.config ||= Configuration.new
    yield config
    self.config.version = "TKK4-HMAC-#{self.config.algorithm.upcase}"
  end

  class Configuration
    attr_accessor :version, :algorithm, :headers,
      :access_key, :secret_access_key, :service, :region, :debug
  end
end
