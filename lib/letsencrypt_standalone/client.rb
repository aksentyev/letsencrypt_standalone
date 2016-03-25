require 'letsencrypt_standalone'
require 'acme/client'
require 'openssl'

module LetsencryptStandalone
  class Client < Base
    attr_reader :account, :email, :acme_client

    def initialize(account: nil, email:)
      @email = email
      @account = account
      @acme_client = Acme::Client.new(private_key: private_key, endpoint: endpoint_url)

      if !account
        logger.warn "Account key not found. Creating..."
        @account = 'account.pem'
        create(email)
        save_account_key
        raise 'No email specified' if !email
      end
    end

    def create(email)
      contact = 'mailto:' + email #https://github.com/schubergphilis/letsencrypt/issues/3
      @acme_client.register(contact: contact).agree_terms
    end

    def authorize(domain:)
      @acme_client.authorize(domain: domain)
    end

    private

    def private_key
      @private_key ||= if account && File.exist?(File.join(path, account))
                         OpenSSL::PKey::RSA.new(File.read(File.join(path, account)))
                       else
                         OpenSSL::PKey::RSA.new(4096)
                       end
    end

    def save_account_key
      logger.info "Saving account key."
      FileUtils.mkdir_p path
      File.new(File.join(path, account), 'w').write(private_key.to_pem)
    end
  end
end
