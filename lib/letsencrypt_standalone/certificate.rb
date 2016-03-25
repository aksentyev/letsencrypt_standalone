require 'letsencrypt_standalone'
require 'fileutils'
require 'acme-client'
require 'openssl'

module LetsencryptStandalone
  class Certificate < Base

    @@default_names = {
               certificate: 'cert.pem',
               chain:       'chain.pem',
               fullchain:   'fullchain.pem'
             }

    attr_reader :files

    def initialize(domain:, client:)
      @files       = domain.certificates || @@default_names
      @domain      = domain.host
      @client      = client
      @private_key = domain.private_key
    end

    def obtain_new
      csr = Acme::Client::CertificateRequest.new(names: Array(@domain), private_key: @private_key)
      @certificate = @client.new_certificate(csr) # => #<Acme::Client::Certificate ....>
      return self
    end

    def needs_refresh?(dir: output_dir)
      cert = @files[:certificate]
      if cert.not_after > Time.now + 2*24*3600
        logger.warn("It doesnt need to refresh cert for domain: #{@domain}")
        false
      else
        logger.warn("It needs to refresh cert for domain: #{@domain}")
        true
      end
    end

    def save(dir: output_dir)

      # Save the certificate and the private key to files
      FileUtils.mkdir_p(File.join(output_dir, @domain))
      File.write(File.join(dir, @domain, @files[:certificate]), @certificate.to_pem)
      File.write(File.join(dir, @domain, @files[:chain]), @certificate.chain_to_pem)
      File.write(File.join(dir, @domain, @files[:fullchain]), @certificate.fullchain_to_pem)
    end
  end
end
