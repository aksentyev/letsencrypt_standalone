require 'letsencrypt_standalone'
require 'acme/client'
require 'openssl'
require 'pry'

module LetsencryptStandalone
  class Client < Base

    def initialize(account: nil, email:, path:)
      @path = path
      @account = account
      @email = email

      @acme_client = Acme::Client.new(private_key: private_key, endpoint: endpoint_url)
      if !account
        create(email)
        raise 'No email specified' if !email
      end
      private_key
    end

    attr_reader :account, :email, :path, :acme_client

    def create(email)
      contact = 'mailto:' + email #https://github.com/schubergphilis/letsencrypt/issues/3
      @acme_client.register(contact: contact).agree_terms
    end

    def authorize(domain:)
      @acme_client.authorize(domain: domain)
    end

    private

    def private_key
      @private_key ||= if account && File.exist?(path + account)
                         OpenSSL::PKey::RSA.new(File.read(path + account))
                       else
                         OpenSSL::PKey::RSA.new(4096)
                       end
    end

    def save_key
      File.write(File.join(output_dir, private_key))
    end
  end
end
