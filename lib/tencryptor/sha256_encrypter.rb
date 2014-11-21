module Tencryptor
  class SHA256Encrypter
    # Encrypt request with elements.
    #
    # @param uri    [URI]
    # @param method [String]
    # @return signature [String] calculated signature
    def signature(uri, method)
      return nil unless uri

      req = cannonical_request(uri, method)
      digest = ::OpenSSL::Digest.new(Tencryptor.configuration.algorithm)

      OpenSSL::HMAC.hexdigest(
        digest,
        signing_key,
        string_to_sign(req)
      )
    end

    private

    # Get cannonical request with request info.
    #
    # @param uri [URI]
    # @param methodh [String]
    # @return cannnonical request [String]
    def cannonical_request(uri, method)
      el = []
      el <<  method
      el << URI.encode_www_form_component(uri.path)
      x_headers = {}
      x_headers['X-Tkk-Algorithm'] = Tencryptor.configuration.version
      x_headers['X-Tkk-Credential'] =
        "#{Tencryptor.configuration.access_key}/#{Time.now.getutc.strftime('%Y%m%d')}" \
        "#{Tencryptor.configuration.region}/tkk4_request"
      x_headers['X-Tkk-Date'] = Time.now.getutc.iso8601
      x_headers['X-Tkk-Expires'] = 86400
      x_headers['X-Tkk-SignedHeaders'] = Tencryptor.configuration.headers.join(',')
      el << URI.encode_www_form(x_headers)
      el << "host: #{uri.host}" # TODO: variant
      el << ''
      el << 'host'
      el << 'UNSIGNED-PAYLOAD'

      el.join("\n")

      Tencryptor.debug(el.join("\n")) if Tencryptor.configuration.debug

      el.join("\n")
    end

    def string_to_sign(req)
      el = [Tencryptor.configuration.version]
      el << Time.now.getutc.iso8601
      el << "#{Time.now.getutc.strftime('%Y%m%d')}/#{Tencryptor.configuration.region}/#{Tencryptor.configuration.service}/tkk4_request"
      el << ::OpenSSL::Digest::SHA256.new.hexdigest(req)

      Tencryptor.debug(el.join("\n")) if Tencryptor.configuration.debug

      el.join("\n")
    end

    def signing_key
      dig = OpenSSL::Digest.new(Tencryptor.configuration.algorithm)
      d = OpenSSL::HMAC.digest(
        dig,
        "TKK4#{Tencryptor.configuration.secret_access_key}",
        Time.now.getutc.strftime('%Y%m%d')
      )
      d = OpenSSL::HMAC.digest(dig, d, Tencryptor.configuration.region)
      d = OpenSSL::HMAC.digest(dig, d, Tencryptor.configuration.service)

      Tencryptor.debug(OpenSSL::HMAC.digest(dig, d, 'tkk4_request')) \
        if Tencryptor.configuration.debug

      OpenSSL::HMAC.digest(dig, d, 'tkk4_request')
    end
  end
end
