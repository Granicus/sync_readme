require 'spec_helper'

describe SyncReadme do
  let(:page) { YAML.load_file('spec/fixtures/pages/readme_page.yml') }
  let(:response) { double('Response', body: page.to_json) }

  it 'has a version number' do
    expect(SyncReadme::VERSION).not_to be nil
  end

  describe '#perform' do
    before :each do
      SyncReadme::Config::DEFAULT_CONFIG_FILE = 'spec/fixtures/config_yml/multiple_entries.yml'.freeze
    end

    it 'runs the code' do
      expect_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
      expect_any_instance_of(Faraday::Connection).to receive(:put)
      SyncReadme.perform('test')
    end
  end

  describe '#invoke' do
    it 'runs on the default when no arguments given' do
      expect(SyncReadme).to receive(:perform).with('test')
      SyncReadme.invoke([])
    end
    it 'runs on the specified file' do
      expect(SyncReadme).to receive(:perform).with('test2')
      SyncReadme.invoke(['test2'])
    end
    it 'runs on all when given --all' do
      expect(SyncReadme).to receive(:perform).twice.with(instance_of(String))
      SyncReadme.invoke(['--all'])
    end
    it 'runs on all when given -a' do
      expect(SyncReadme).to receive(:perform).twice.with(instance_of(String))
      SyncReadme.invoke(['-a'])
    end
  end
end
