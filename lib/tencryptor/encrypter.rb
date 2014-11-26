require 'time'
require 'uri'

module Tencryptor
  class Encrypter
    def initialize
      encrypter = "#{Tencryptor.config.algorithm.upcase}Encrypter"
      @encrypter = Tencryptor.const_get(encrypter).new
    end

    def signed_parameters(uri, method = 'get')
      @encrypter.signed_parameters(uri, method)
    end
  end
end
