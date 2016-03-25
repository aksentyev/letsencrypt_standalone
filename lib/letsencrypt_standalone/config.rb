require 'letsencrypt_standalone'

module LetsencryptStandalone
  class Config < Base
    attr_accessor :config, :location, :port
    def initialize(config_file: nil)
      @location ||= 'le_standalone.json'
      @config = JSON.parse(File.read(@location), :symbolize_names => true)
    end

    def output_dir
      config.output_dir || super
    end

    %i(account domains email path).each do |meth|
      define_method meth do
        config.fetch(meth, nil)
      end
    end

    def tries
      config.fetch(:tries, 5)
    end

    def push_certs_locations(files:, domain:)
      config[:domains].map! do |d|
        d[:host] == domain.host ? d.merge(files) : d
      end
    end

    def push_private_key_location(domain:)
      config[:domains].map! do |d|
        d[:host] == domain.host ? d.merge(private_key: domain.private_key_name) : d
      end
    end

    def write
      File.new(location, 'w').write(JSON.pretty_generate(config))
    end
  end
end
