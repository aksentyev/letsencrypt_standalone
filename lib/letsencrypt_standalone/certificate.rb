require 'letsencrypt_standalone'
require 'fileutils'

module LetsencryptStandalone
  class Certificate < Base
    require 'acme-client'
    require 'openssl'

    @@default_names = {
               private_key: 'privkey.pem',
               certificate: 'cert.pem',
               chain:       'chain.pem',
               fullchain:   'fullchain.pem'
             }

    def initialize(domain:, client:, files_names: @@default_names )
      @names       = files_names
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
      cert = load(path: File.join(dir, @domain, @names[:certificate]))
      if cert.not_after > Time.now + 2*24*3600
        logger.warn("It doesnt need to refresh cert for domain: #{domain}")
        false
      else
        logger.warn("It needs to refresh cert for domain: #{domain}")
        true
      end
    end

    def save(dir: output_dir)

      # Save the certificate and the private key to files
      FileUtils.mkdir_p(File.join(output_dir, @domain))
      File.write(File.join(dir, @domain, @names[:private_key]), @certificate.request.private_key.to_pem)
      File.write(File.join(dir, @domain, @names[:certificate]), @certificate.to_pem)
      File.write(File.join(dir, @domain, @names[:chain]), @certificate.chain_to_pem)
      File.write(File.join(dir, @domain, @names[:fullchain]), @certificate.fullchain_to_pem)
    end

    def files
      @names
    end

    def output_dir
      super
    end

    def load(path:)
      OpenSSL::X509::Certificate.new(File.read(path))
    end
  end
end
