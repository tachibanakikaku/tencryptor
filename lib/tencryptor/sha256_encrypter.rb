module Tencryptor
  class SHA256Encrypter
    # Get query parameters including signed information
    #
    # @param uri [URI]
    # @param method [String] HTTP verb
    # @return [Hash] signed query parameters
    def signed_parameters(uri, method)
      @enc_time = Time.now

      params =
        uri.query.nil? ? {} : Hash[URI::decode_www_form(uri.query)]
      params['X-Tkk-Algorithm'] = Tencryptor.config.version
      params['X-Tkk-Credential'] =
        "#{Tencryptor.config.access_key}/" \
        "#{@enc_time.getutc.strftime('%Y%m%d')}/" \
        "#{Tencryptor.config.region}/" \
        "#{Tencryptor.config.service}/" \
        "tkk4_request"
      params['X-Tkk-Date'] =  @enc_time.iso8601
      params['X-Tkk-Expires'] = 86400
      params['X-Tkk-SignedHeaders'] = Tencryptor.config.headers.join(';')
      params['X-Tkk-Signature'] = signature(uri, method, params)

      params
    end

    private

    # Encrypt request with elements.
    #
    # @param uri    [URI]
    # @param method [String] HTTP verb
    # @param params [Hash] signed parameters
    # @return [String] calculated signature
    def signature(uri, method = get, params = {})
      req = cannonical_request(uri, method, params)
      digest = ::OpenSSL::Digest.new(Tencryptor.config.algorithm)

      OpenSSL::HMAC.hexdigest(
        digest,
        signing_key,
        string_to_sign(req)
      )
    end

    # Get cannonical request with request info.
    #
    # @param uri [URI]
    # @param method [String]
    # @param params [Hash] signed parameters
    # @return [String] cannnonical request
    def cannonical_request(uri, method, params)
      el = []
      el <<  method
      el << URI.encode_www_form_component(uri.path)
      el << URI.encode_www_form(Hash[params.sort])
      el << "host: #{uri.host}" # TODO: make variant
      el << ''
      el << Tencryptor.config.headers.map { |m| m.downcase } .join(';')
      el << 'UNSIGNED-PAYLOAD'

      req = el.join("\n")
      Tencryptor.debug(req) if Tencryptor.config.debug
      req
    end

    def signing_key
      dig = OpenSSL::Digest.new(Tencryptor.config.algorithm)
      d = OpenSSL::HMAC.digest(
        dig,
        "TKK4#{Tencryptor.config.secret_access_key}",
        @enc_time.getutc.strftime('%Y%m%d')
      )
      d = OpenSSL::HMAC.digest(dig, d, Tencryptor.config.region)
      d = OpenSSL::HMAC.digest(dig, d, Tencryptor.config.service)

      s_key = OpenSSL::HMAC.digest(dig, d, 'tkk4_request')
      Tencryptor.debug(s_key) if Tencryptor.config.debug
      s_key
    end

    def string_to_sign(req)
      el = [Tencryptor.config.version]
      el << @enc_time.getutc.iso8601
      scope = "#{@enc_time.getutc.strftime('%Y%m%d')}/" \
        "#{Tencryptor.config.region}/" \
        "#{Tencryptor.config.service}/" \
        "tkk4_request"
      el << scope
      el << ::OpenSSL::Digest::SHA256.new.hexdigest(req)

      s_to_s = el.join("\n")
      Tencryptor.debug(s_to_s) if Tencryptor.config.debug
      s_to_s
    end
  end
end
