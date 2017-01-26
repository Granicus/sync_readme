require 'kramdown'

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
      value = Kramdown::Document.new(markdown, input: 'GFM').to_html
      value = "#{@notice}#{value}" if @notice
      value
    end
  end
end
