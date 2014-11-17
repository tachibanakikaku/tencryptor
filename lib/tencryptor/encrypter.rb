module Tencryptor
  class Encrypter
    def initialize
      @algorithm = 'TKK4-HMAC-SHA256'
      @access_key = 'your_access_key'
      @secret_access_key = 'your_secret_access_key'
      @region = 'tokyo'
      @headers = ['host'] # currently only 'host'
      @debug = true
    end

    def authorization_signature(method, uri)
      req = cannonical_request(method, uri)
      dig = OpenSSL::Digest.new('sha256')
      signature =
        OpenSSL::HMAC.hexdigest(dig, signing_key, string_to_sign(req))

      dump("#{@access_key}:#{signature}") if @debug

      "#{@access_key}:#{signature}"
    end

    private

    def cannonical_request(method, uri)
      el = [method]
      el << URI.encode_www_form_component(uri.path)
      x_headers = {}
      x_headers['X-Tkk-Algorithm'] = @algorithm
      x_headers['X-Tkk-Credential'] = "#{@access_key}/#{Time.now.getutc.strftime('%Y%m%d')}/#{@region}/tkk4_request"
      x_headers['X-Tkk-Date'] = Time.now.getutc.iso8601
      x_headers['X-Tkk-Expires'] = 86400
      x_headers['X-Tkk-SignedHeaders'] = @headers.join(',')
      el << URI.encode_www_form(x_headers)
      el << "host: #{uri.host}" # TODO: variant
      el << ''
      el << 'host'
      el << 'UNSIGNED-PAYLOAD'
      el.join("\n")

      dump(el.join("\n")) if @debug

      el.join("\n")
    end

    def string_to_sign(req)
      el = [@algorithm]
      el << Time.now.getutc.iso8601
      el << "#{Time.now.getutc.strftime('%Y%m%d')}/#{@region}/errnow/tkk4_request"
      el << OpenSSL::Digest::SHA256.new.hexdigest(req)

      dump(el.join("\n")) if @debug

      el.join("\n")
    end

    def signing_key
      dig = OpenSSL::Digest.new('sha256')
      d = OpenSSL::HMAC.digest(
        dig,
        "TKK4#{@secret_access_key}",
        Time.now.getutc.strftime('%Y%m%d')
      )
      d = OpenSSL::HMAC.digest(dig, d, 'tokyo')
      d = OpenSSL::HMAC.digest(dig, d, 'errnow')

      dump(OpenSSL::HMAC.digest(dig, d, 'tkk4_request')) if @debug

      d = OpenSSL::HMAC.digest(dig, d, 'tkk4_request')
    end

    def dump(data)
      Logger.new(STDOUT).debug(data)
    end
  end
end
