require 'letsencrypt_standalone'

module LetsencryptStandalone
  class Config < Base
    attr_accessor :config, :location
    def initialize(config_file: nil)
      @location ||= 'le_standalone.json'
      @config = JSON.parse(File.read(@location), :symbolize_names => true)
    end

    def output_dir
      config.output_dir || super #TODO TBD
    end

    %i(account domains email path).each do |meth|
      define_method meth do
        config.fetch(meth, nil)
      end
    end

    def tries
      config.fetch(:tries, 5)
    end

    def push_certs(files:, domain:)
      config[:domains].map! do |d|
        d.merge(:certificates => files) if d[:host] == domain.host
      end
    end

    def write
      File.new(location, 'w').write(JSON.pretty_generate(config))
    end
  end
end
