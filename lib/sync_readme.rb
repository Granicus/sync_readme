require 'sync_readme/errors'
require 'sync_readme/config'
require 'sync_readme/confluence_sync'
require 'sync_readme/reader'
require 'sync_readme/version'
require 'optparse'
require 'dotenv'
require 'highline/import'

Dotenv.load

module SyncReadme
  def self.invoke(args)
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: sync_readme [options] [profile]'

      opts.on('-u', '--user=username', String, 'Confluence username') do |user|
        ENV['CONFLUENCE_USERNAME'] = user
        ENV['CONFLUENCE_PASSWORD'] = ask("Password for #{user}: ") { |q| q.echo = false }
      end

      opts.on('-a', '--all', 'Run all configured syncronizations') do
        options[:all] = true
      end

      opts.on_tail('-h', '--help', 'Show help') do
        puts opts
        exit
      end
    end.parse!(args)

    ENV['CONFLUENCE_USERNAME'] ||= ask("Confluence username: ")
    ENV['CONFLUENCE_PASSWORD'] ||= ask("Password for #{ENV['CONFLUENCE_USERNAME']}: ") { |q| q.echo = false }

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

  rescue SyncReadme::Error => sre
    STDERR.puts sre.message
    exit 1
  end

  def self.perform(profile)
    config = SyncReadme::Config.new(profile)
    content = SyncReadme::Reader.new(config).html
    sync = SyncReadme::ConfluenceSync.new(config)
    sync.update_page_content(content)
  end
end
