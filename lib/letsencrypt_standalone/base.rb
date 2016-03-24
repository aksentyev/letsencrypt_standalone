require 'letsencrypt_standalone'

module LetsencryptStandalone
  require 'logger'
  class Base
    # Logger
    @@logger = Logger.new(STDOUT)
    @@logger.level = Logger::WARN

    def logger
      @@logger
    end

    def endpoint_url
      ENV['LE_ENVIRONMENT'] == 'staging' ? STAGE_URL : PROD_URL
    end

    def output_dir
      'ssl_certs/'
    end
  end
end
