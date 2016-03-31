require 'letsencrypt_standalone'

module LetsencryptStandalone
  require 'logger'
  class Base
    class << self
      def logger(log_destination: STDOUT)
        @@logger = Logger.new(log_destination)
        @@logger.level = Logger::INFO
        @@logger
      end
    end

    def logger
      @@logger
    end

    def endpoint_url
      ENV['LE_ENVIRONMENT'] == 'staging' ? STAGE_URL : PROD_URL
    end

    def output_dir
      File.join(path, ssl_subdir)
    end

    def ssl_subdir
      @ssl_subdir ||= LetsencryptStandalone::Config.new.ssl_subdir
    end

    def path
      @path ||= LetsencryptStandalone::Config.new.config[:path]
    end
  end
end
