require 'sync_readme/config'
require 'sync_readme/confluence_sync'
require 'sync_readme/reader'
require 'sync_readme/version'
require 'optparse'
require 'dotenv'

Dotenv.load

module SyncReadme
  def self.invoke(args)
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: sync_readme [options] [profile]"

      opts.on("-a", "--all", "Run verbosely") do
        options[:all] = true
      end
    end.parse!(args)

    default_profile = SyncReadme::Config.default

    if options[:all] || (args.empty? && default_profile.nil?)
      SyncReadme::Config.profiles.each do |profile|
        SyncReadme.perform(profile)
      end
    elsif args.empty?
      SyncReadme.perform(default_profile)
    else
      SyncReadme.perform(args.last)
    end
  end

  def self.perform(profile)
    config = SyncReadme::Config.new(profile)
    content = SyncReadme::Reader.new(config).html
    sync = SyncReadme::ConfluenceSync.new(config)
    sync.update_page_content(content)
  end
end
