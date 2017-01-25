require 'spec_helper'

describe SyncReadme::Reader do
  context '#html' do
    it 'returns valid html for h1' do
      config = instance_double('SyncReadme::Config', filename: 'spec/fixtures/markdown/h1.md', notice: nil)
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to eq("<h1 id=\"hello\">Hello</h1>\n")
    end
    it 'returns valid html for h2' do
      config = instance_double('SyncReadme::Config', filename: 'spec/fixtures/markdown/h2.md', notice: nil)
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to eq("<h2 id=\"hello\">Hello</h2>\n")
    end
    it 'returns valid html for h3' do
      config = instance_double('SyncReadme::Config', filename: 'spec/fixtures/markdown/h3.md', notice: nil)
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to eq("<h3 id=\"hello\">Hello</h3>\n")
    end
    it 'returns valid html for code blocks' do
      config = instance_double('SyncReadme::Config', filename: 'spec/fixtures/markdown/code.md', notice: nil)
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to eq("<pre><code>CODE\nNew line of cod\n</code></pre>\n")
    end

    it 'injects a notice into the file if specified in the config' do
      config = instance_double('SyncReadme::Config', filename: 'spec/fixtures/markdown/h3.md', notice: 'this file is syncd')
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to eq("this file is syncd<h3 id=\"hello\">Hello</h3>\n")
    end
  end
end
