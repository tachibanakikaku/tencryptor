# Tencryptor

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

Execute encryption like this:

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
p t.signature(URI('https://github.com/'))
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tencryptor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
