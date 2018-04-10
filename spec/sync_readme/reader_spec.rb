require 'spec_helper'

describe SyncReadme::Reader do
  let(:options) { { toc: nil, filename: nil, notice: nil, strip_title?: false, syntax_highlighting?: true } }
  context '#html' do
    it 'returns valid html for h1' do
      options[:strip_title?] = false
      options[:filename] = 'spec/fixtures/markdown/h1.md'
      config = instance_double('SyncReadme::Config', options)
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to eq("<h1 id=\"hello\">Hello</h1>\n")
    end
    it 'returns valid html for h2' do
      options['filename'] = 'spec/fixtures/markdown/h2.md'
      config = instance_double('SyncReadme::Config', options)
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to eq("<h2 id=\"hello\">Hello</h2>\n")
    end
    it 'returns valid html for h3' do
      options['filename'] = 'spec/fixtures/markdown/h3.md'
      config = instance_double('SyncReadme::Config', options)
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to eq("<h3 id=\"hello\">Hello</h3>\n")
    end
    it 'returns valid html for code blocks' do
      options['filename'] = 'spec/fixtures/markdown/code.md'
      config = instance_double('SyncReadme::Config', options)
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to eq("<pre><code>CODE\nNew line of cod\n</code></pre>\n")
    end
    it 'injects a notice into the file if specified in the confg' do
      options['filename'] = 'spec/fixtures/markdown/h3.md'
      options['notice'] = 'this file is syncd'
      config = instance_double('SyncReadme::Config', options)
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to eq("<p>this file is syncd</p>\n<h3 id=\"hello\">Hello</h3>\n")
    end
    it 'injects a ToC into the file if specified in the confg' do
      options['filename'] = 'spec/fixtures/markdown/h3.md'
      options['toc'] = true
      config = instance_double('SyncReadme::Config', options)
      reader = SyncReadme::Reader.new(config)
      html = reader.html
      expect(html.scan(/(?=#{'ac:parameter'})/).count).to eq 20
      expect(html.scan(/(?=#{'ac:structured-macro'})/).count).to eq 2
    end
    it 'injects a ToC into the file if specified in the confg' do
      options['filename'] = 'spec/fixtures/markdown/h3.md'
      options['toc'] = {'style' => 'circle'}
      config = instance_double('SyncReadme::Config', options)
      reader = SyncReadme::Reader.new(config)
      html = reader.html
      expect(html.scan(/(?=#{'ac:parameter'})/).count).to eq 20
      expect(html.scan(/(?=#{'<ac:parameter ac:name="style">circle</ac:parameter>'})/).count).to eq 1
      expect(html.scan(/(?=#{'ac:structured-macro'})/).count).to eq 2
    end
    it 'strips out a title' do
      options[:strip_title?] = true
      options['filename'] = 'spec/fixtures/markdown/title.md'
      config = instance_double('SyncReadme::Config', options)
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to eq("<h3 id=\"halp\">Halp</h3>\n")
    end
    it 'highlights ruby syntax' do
      options[:strip_title?] = true
      options['filename'] = 'spec/fixtures/markdown/ruby_code.md'
      config = instance_double('SyncReadme::Config', options)
      reader = SyncReadme::Reader.new(config)
      expect(reader.html).to include('<td class="code"><pre><span style="color:#036;font-weight:bold">Foo</span>.bar')
      expect(reader.html).to include('<td class="line-numbers"><pre><a href="#n1" name="n1">1</a>')
    end
  end
end
