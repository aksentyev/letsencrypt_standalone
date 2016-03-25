require 'letsencrypt_standalone'
require 'openssl'
require 'fileutils'

module LetsencryptStandalone
  class Domain < Base
    attr_accessor :host, :private_key, :certificates
    attr_reader :private_key_name

    @@default_private_key_name = 'private_key.pem'

    def initialize(params:, path: './')
      @host = params.fetch(:host)
      @private_key_name = params.fetch(:private_key, @@default_private_key_name)
      default_path(path: path)

      if params.has_key? :certificates
        load_certs(params)
      end
      load_private_key
    end

    def private_key_location
      @private_key_location ||= File.join(default_path, @private_key_name)
    end

    private

    def load_private_key
      logger.info "Trying to use existing private key for #{@host}"
      if File.exists? File.join(default_path, @private_key_name)
        @private_key = OpenSSL::PKey::RSA.new(File.read(File.join(default_path, @private_key_name)))
      else
        @private_key = generate_key
        save_private_key
      end
    end

    def save_private_key
      FileUtils.mkdir_p(default_path)
      File.new(private_key_location, 'w').write(@private_key.to_pem)
    end

    def load_certs(params)
      @certificates = {}
      params[:certificates].each do |type, file|
        cert = OpenSSL::X509::Certificate.new(File.read(File.join(default_path, file)))
        @certificates[type] = cert
        logger.info "Trying to use existing cert #{type} for #{@host}"
      end
    end

    def default_path(path: nil)
      @default_path ||= File.join(path, output_dir, host)
    end

    def generate_key
      OpenSSL::PKey::RSA.new(4096)
    end
  end
end
