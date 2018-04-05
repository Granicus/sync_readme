require 'spec_helper'
require 'yaml'

describe SyncReadme::ConfluenceSync do
  let(:config) { SyncReadme::Config.new('test', 'spec/fixtures/config_yml/multiple_entries.yml') }
  let(:page) { YAML.load_file('spec/fixtures/pages/readme_page.yml') }
  let(:response) { double('Response', body: page.to_json) }
  subject { SyncReadme::ConfluenceSync.new(config) }
  it 'initializes a confluence api client' do
    expect(subject.instance_variable_get(:@client)).to be_a(Faraday::Connection)
  end
  it 'sets the page_id to the provided value' do
    expect(subject.instance_variable_get(:@page_id)).to eq(12_345)
  end

  describe "#increment_version" do
    it 'increments the current version by one' do
      expect(subject.increment_version(page)).to eq(17)
    end
  end

  describe "#get_page" do
    it 'calls get on the client' do
      expect_any_instance_of(Faraday::Connection).to receive(:get).with("rest/api/content/12345", expand: 'body.view,version').and_return(response)
      subject.get_page
    end
  end

  describe "#update"

  describe "#updated_page_params" do
    it 'keeps the existing title' do
      expect(subject.updated_page_params(page, 'foo')[:title]).to eq('Title')
    end
    it 'uses the new content' do
      expect(subject.updated_page_params(page, 'foo')[:body][:storage][:value]).to eq('foo')
    end
    it 'updates the version' do
      expect(subject.updated_page_params(page, 'foo')[:version][:number]).to eq(17)
    end
  end

  describe "#update_page_content" do
    it 'sends data to confluence' do
      expect_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
      expect_any_instance_of(Faraday::Connection).to receive(:put).and_return(response)
      subject.update_page_content('foo')
    end
  end
end
