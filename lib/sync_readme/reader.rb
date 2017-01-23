require 'redcarpet'

module SyncReadme
  class Reader
    def initialize(config)
      @file_contents = File.read(config.filename)
    end

    def html
      renderer = Redcarpet::Render::HTML.new(with_toc_data: true)
      converter = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)
      converter.render(@file_contents)
    end
  end
end
