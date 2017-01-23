require 'spec_helper'

describe SyncReadme::Config do
  context 'class methods' do
    context '#profiles' do
      it 'returns empty' do
        file = 'spec/fixtures/config_yml/empty_config.yml'
        expect(SyncReadme::Config.profiles(file)).to be_empty
      end
      it 'returns a single profile if only one is configured' do
        file = 'spec/fixtures/config_yml/one_entry.yml'
        profiles = SyncReadme::Config.profiles(file)
        expect(profiles).not_to be_empty
        expect(profiles).to contain_exactly('test')
      end
      it 'returns two profiles from the multiple configured file' do
        file = 'spec/fixtures/config_yml/multiple_entries.yml'
        profiles = SyncReadme::Config.profiles(file)
        expect(profiles).not_to be_empty
        expect(profiles).to contain_exactly('test', 'test2')
      end
      it 'returns a single profile if only one is configured with no default' do
        file = 'spec/fixtures/config_yml/no_default_single.yml'
        profiles = SyncReadme::Config.profiles(file)
        expect(profiles).not_to be_empty
        expect(profiles).to contain_exactly('test')
      end
      it 'returns two profiles from the multiple configured file with no default' do
        file = 'spec/fixtures/config_yml/no_default_multiple.yml'
        profiles = SyncReadme::Config.profiles(file)
        expect(profiles).not_to be_empty
        expect(profiles).to contain_exactly('test', 'test2')
      end
    end

    context '#default' do
      it 'raises error if config has no default and more than one entry' do
        file = 'spec/fixtures/config_yml/no_default_multiple.yml'
        expect { SyncReadme::Config.default(file) }.to raise_error(SyncReadme::Config::DEFAULT_NOT_FOUND_ERROR)
      end
      it 'returns the only configured option' do
        file = 'spec/fixtures/config_yml/no_default_single.yml'
        expect(SyncReadme::Config.default(file)).to eq('test')
      end
      it 'returns the default specified in single' do
        file = 'spec/fixtures/config_yml/one_entry.yml'
        expect(SyncReadme::Config.default(file)).to eq('test')
      end
      it 'returns the default specified in multiple' do
        file = 'spec/fixtures/config_yml/multiple_entries.yml'
        expect(SyncReadme::Config.default(file)).to eq('test')
      end
    end
  end

  context 'instance methods' do
    let(:config) { SyncReadme::Config.new('test', file) }

    shared_examples_for 'a config file' do
      it 'throws an error on initialization if profile does not exist' do
        expect do
          SyncReadme::Config.new('foo', file)
        end.to raise_error(SyncReadme::Config::NO_CONFIGURATION_ERROR)
      end
      it 'returns the expected url' do
        expect(config.url).to eq('https://confluence.test.com')
      end
      it 'returns the expected page id' do
        expect(config.page_id).to eq(12_345)
      end
      it 'returns the expected filename' do
        expect(config.filename).to eq('README.md')
      end

      context 'credentials, env set' do
        before :each do
          ENV['CONFLUENCE_USERNAME'] = 'foo'
          ENV['CONFLUENCE_PASSWORD'] = 'bar'
        end

        it 'returns the password from the environement variable' do
          expect(config.password).to eq('bar')
        end
        it 'returns the username from the environement variable' do
          expect(config.username).to eq('foo')
        end
      end

      context 'credentials, env not set' do
        before :each do
          ENV['CONFLUENCE_USERNAME'] = nil
          ENV['CONFLUENCE_PASSWORD'] = nil
        end

        it 'returns the password from the config' do
          expect(config.password).to eq('password')
        end
        it 'returns the username from the config' do
          expect(config.username).to eq('boo')
        end
      end
    end

    context 'no entries' do
      let(:file) { 'spec/fixtures/config_yml/empty_config.yml' }
      it 'throws an error on initialization if profile does not exist' do
        expect do
          SyncReadme::Config.new('foo', file)
        end.to raise_error(SyncReadme::Config::NO_CONFIGURATION_ERROR)
      end
    end

    context 'single entry' do
      let(:file) { 'spec/fixtures/config_yml/one_entry.yml' }
      it_behaves_like 'a config file'
    end

    context 'multiple entries' do
      let(:file) { 'spec/fixtures/config_yml/multiple_entries.yml' }
      it_behaves_like 'a config file'
    end

    context 'single entry, no default' do
      let(:file) { 'spec/fixtures/config_yml/no_default_single.yml' }
      it_behaves_like 'a config file'
    end

    context 'multiple entries, no default' do
      let(:file) { 'spec/fixtures/config_yml/no_default_multiple.yml' }
      it_behaves_like 'a config file'
    end
  end
end
