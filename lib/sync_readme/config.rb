require 'yaml'

module SyncReadme
  class Config
    DEFAULT_CONFIG_FILE = File.join(Dir.pwd, '.sync_readme.yml')
    DEFAULT_NOT_FOUND_ERROR = 'default not configured, add "default: [your default here]" to your config'.freeze
    NO_CONFIGURATION_ERROR = "this profile has not been configured, please add it to #{DEFAULT_CONFIG_FILE}".freeze

    def self.profiles(config_file = DEFAULT_CONFIG_FILE)
      YAML.load_file(config_file).keys.select { |key| key != 'default' }
    end

    def self.default(config_file = DEFAULT_CONFIG_FILE)
      default = YAML.load_file(config_file)['default']
      unless default
        profiles = SyncReadme::Config.profiles(config_file)
        return profiles[0] unless profiles.empty? || profiles[1]
        raise DEFAULT_NOT_FOUND_ERROR
      end
      default
    end

    def initialize(profile, config_file = DEFAULT_CONFIG_FILE)
      @raw_config = YAML.load_file(config_file)[profile]
      raise NO_CONFIGURATION_ERROR unless @raw_config
    end

    def url
      @raw_config['url']
    end

    def username
      ENV['CONFLUENCE_USERNAME'] || @raw_config['username']
    end

    def notice
      @raw_config['notice']
    end

    def password
      ENV['CONFLUENCE_PASSWORD'] || @raw_config['password']
    end

    def strip_title?
      @raw_config['strip_title'].nil? ? false : @raw_config['strip_title']
    end

    def page_id
      @raw_config['page_id']
    end

    def filename
      @raw_config['filename']
    end
  end
end
