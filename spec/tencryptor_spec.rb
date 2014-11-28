require 'spec_helper'

describe Tencryptor do
  it 'has a version number' do
    expect(Tencryptor::VERSION).not_to be nil
  end

  context 'when configuration prepared' do
    let(:algorithm)  { 'sha256' }
    let(:service)    { 'my-service' }
    let(:headers)    { ['host'] }
    let(:region)     { 'asia/tokyo' }
    let(:access_key) { 'my-access-key' }
    let(:secret_key) { 'my-secret-key' }
    let(:version)    { "TKK4-HMAC-#{algorithm.upcase}" }
    
    before do
      Tencryptor.configure do |config|
        config.algorithm         = algorithm
        config.service           = service
        config.headers           = headers
        config.region            = region
        config.access_key        = access_key
        config.secret_access_key = secret_key
      end
    end

    describe 'configuration is properly set' do
      it { expect(Tencryptor.config.algorithm).to eq algorithm }
      it { expect(Tencryptor.config.service).to eq service }
      it { expect(Tencryptor.config.headers).to eq headers }
      it { expect(Tencryptor.config.region).to eq region }
      it { expect(Tencryptor.config.access_key).to eq access_key }
      it { expect(Tencryptor.config.secret_access_key).to eq secret_key }
      it { expect(Tencryptor.config.version).to eq version }
    end

    describe 'Enctypter' do
      it { expect(Tencryptor::Encrypter).to respond_to :new }
      it { expect(Tencryptor::Encrypter.new).to respond_to :signed_parameters }
    end

    describe 'SHA256Encrypter' do
      let(:enc) { Tencryptor::Encrypter.new }
      let(:uri) { URI('http://localhost/') }
      let(:xheaders) {
        %w[
          X-Tkk-Algorithm
          X-Tkk-Credential
          X-Tkk-Date
          X-Tkk-Expires
          X-Tkk-SignedHeaders
          X-Tkk-Signature
        ]
      }

      describe '#signed_parameters' do
        let(:signed_params) { enc.signed_parameters(uri, 'get') }

        it 'signed_params has xheaders' do
          xheaders.each do |h|
            expect(signed_params).to include(h)
          end
        end
      end
    end
  end
end
