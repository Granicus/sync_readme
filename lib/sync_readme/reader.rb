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
      markdown.sub!(/# .*\n/, '') if @strip_title
      renderer = Redcarpet::Render::HTML.new(with_toc_data: true)
      converter = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)
      value = converter.render(@file_contents)
      value = "#{@notice}#{value}" if @notice
      value
    end
  end
end
