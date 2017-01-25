require 'redcarpet'

module SyncReadme
  class Reader
    def initialize(config)
      @file_contents = File.read(config.filename)
      @notice = config.notice
    end

    def html
      renderer = Redcarpet::Render::HTML.new(with_toc_data: true)
      converter = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)
      value = converter.render(@file_contents)
      if @notice
        value = "#{@notice}#{value}"
      end
      value
    end
  end
end
