require 'letsencrypt_standalone'
require 'openssl'
require 'fileutils'

module LetsencryptStandalone
  class Domain < Base
    attr_accessor :host, :private_key, :certificates
    attr_reader :private_key_name, :private_key_path

    @@default_private_key_name = 'private_key.pem'

    def initialize(params:, path: './')
      @host = params.fetch(:host)
      @private_key_name = params.fetch(:private_key, @@default_private_key_name)
      @private_key_path = File.join(output_dir,@host, @private_key_name)

      if params.has_key? :certificates
        load_certs(params)
      end
      load_private_key
    end

    def host_dir
      @host_dir ||= File.join(output_dir, host)
    end

    def validate(client:)
      authorization = client.authorize(domain: self.host)
      #The http-01 method will require you to respond to a HTTP request.
      @challenge = authorization.http01

      # Save the file. We'll create a public directory to serve it from, and inside it we'll create the challenge file.
      FileUtils.mkdir_p(File.join(config.www_root, File.dirname(@challenge.filename)))

      # We'll write the content of the file
      File.write(File.join(config.www_root, @challenge.filename), @challenge.file_content)

      # try to verify
      @challenge.request_verification
    end

    def verify_status
      @challenge.verify_status
    end

    private

    def load_private_key
      logger.info "Trying to use existing private key for #{@host}"
      if File.exists? File.join(host_dir, @private_key_name)
        @private_key = OpenSSL::PKey::RSA.new(File.read(@private_key_path))
      else
        @private_key = generate_key
        save_private_key
      end
    end

    def config
      @config ||= LetsencryptStandalone::Config.new
    end

    def create_host_dir
      FileUtils.mkdir_p(host_dir)
    end

    def save_private_key
      create_host_dir
      File.new(@private_key_path, 'w').write(@private_key.to_pem)
    end

    def load_certs(params)
      @certificates = {}
      params[:certificates].each do |type, file|
        cert = OpenSSL::X509::Certificate.new(File.read(File.join(host_dir, file)))
        @certificates[type] = cert
        logger.info "Trying to use existing cert #{type} for #{@host}"
      end
    end

    def generate_key
      OpenSSL::PKey::RSA.new(4096)
    end
  end
end
