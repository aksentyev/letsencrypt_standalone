require 'letsencrypt_standalone'
require 'openssl'

module LetsencryptStandalone
  class Domain
    attr_accessor :host, :private_key, :certificates
    def initialize(params)
      @host        = params.fetch(:host)
      @private_key = params.fetch(:private_key, nil)
      @certificates = params.fetch(:certificates, nil)
    end

    def private_key
      @private_key ||= OpenSSL::PKey::RSA.new(4096)
    end
  end
end
