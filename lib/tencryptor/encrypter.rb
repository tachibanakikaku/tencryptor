require 'time'
require 'uri'

module Tencryptor
  class Encrypter
    def initialize
      encrypter = "#{Tencryptor.configuration.algorithm.upcase}Encrypter"
      @encrypter = Tencryptor.const_get(encrypter).new
    end

    def signature(uri, method = 'get')
      @encrypter.signature(uri, method)
    end
  end
end
