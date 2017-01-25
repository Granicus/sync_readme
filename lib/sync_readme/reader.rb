require 'redcarpet'

module SyncReadme
  class Reader
    def initialize(config)
      @file_contents = File.read(config.filename)
      @notice = config.notice
      @strip_title = config.strip_title?
    end

    def html
      markdown = @file_contents
      if @strip_title
        markdown.sub!(/# .*\n/, '')
      end
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
