# Tencryptor

[![Build Status](https://travis-ci.org/tachibanakikaku/tencryptor.svg)](https://travis-ci.org/tachibanakikaku/tencryptor)

Encryption module.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tencryptor', git: 'https://github.com/tachibanakikaku/tencryptor.git'
```

And then execute:

```bash
$ bundle
```

## Usage

Generate signed parameters (including signature) like this:

```ruby
Tencryptor.configure do |config|
  config.algorithm         = 'sha256'
  config.service           = 'my-service'
  config.headers           = ['host']
  config.region            = 'asia/tokyo'
  config.access_key        = 'my-access-key'
  config.secret_access_key = 'my-secret_access-key'
  config.debug             = true
end

t = Tencryptor::Encrypter.new
t.signed_parameters(URI('https://github.com/?b=xxx&a=YYY&C=mmm'))
#=> {"b"=>"xxx", "a"=>"YYY", "C"=>"mmm", "X-Tkk-Algorithm"=>"TKK4-HMAC-SHA256", "X-Tkk-Credential"=>"my-access-key/20141126/asia/tokyo/my-service/tkk4_request", "X-Tkk-Date"=>"2014-11-27T02:22:10+09:00", "X-Tkk-Expires"=>86400, "X-Tkk-SignedHeaders"=>"host", "X-Tkk-Signature"=>"e6f8c0f17f534bf3957d3d1224ef63776920b8194279ad4110aedcf54ff164d7"}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tencryptor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
