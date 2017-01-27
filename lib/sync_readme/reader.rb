require 'kramdown'

module SyncReadme
  class Reader
    def initialize(config)
      @file_contents = File.read(config.filename)
      @notice = config.notice
      @strip_title = config.strip_title?
      @highlighter = config.syntax_highlighting? ? 'coderay' : nil
    end

    def html
      markdown = @file_contents
      markdown.sub!(/# .*\n/, '') if @strip_title
      options = {
        input: 'GFM',
        syntax_highlighter: @highlighter,
        syntax_highlighter_opts: {
          css: 'style',
          line_numbers: 'table'
        }
      }
      value = Kramdown::Document.new(markdown, options).to_html
      value = "#{@notice}#{value}" if @notice
      value
    end
  end
end
