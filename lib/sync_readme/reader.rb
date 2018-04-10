require 'kramdown'

module SyncReadme
  class Reader
    def initialize(config)
      @file_contents = File.read(config.filename)
      @notice = config.notice
      @toc = config.toc
      @strip_title = config.strip_title?
      @highlighter = config.syntax_highlighting? ? 'coderay' : nil
    end

    # See here for ToC parameters
    # https://confluence.atlassian.com/display/CONF55/Table+of+Contents+Macro
    def toc
      return '' unless @toc
      @toc = {} unless @toc.is_a?(Hash)
      params = {
        'printable' => true,
        'style' => 'circle',
        'maxLevel' => 2,
        'indent' => '5px',
        'minLevel' => 2,
        'exclude' => '[1/2]',
        'outline' => true,
        'type' => 'list',
        'include' => '.*',
        'class' => 'sync_readme_toc'
        }.merge(@toc)

      return <<-TOC
      <ac:structured-macro ac:name="toc">
        <ac:parameter ac:name="printable">#{params['printable']}</ac:parameter>
        <ac:parameter ac:name="style">#{params['style']}</ac:parameter>
        <ac:parameter ac:name="maxLevel">#{params['maxLevel']}</ac:parameter>
        <ac:parameter ac:name="indent">#{params['indent']}</ac:parameter>
        <ac:parameter ac:name="minLevel">#{params['minLevel']}</ac:parameter>
        <ac:parameter ac:name="class">#{params['class']}</ac:parameter>
        <ac:parameter ac:name="exclude">#{params['exclude']}</ac:parameter>
        <ac:parameter ac:name="type">#{params['type']}</ac:parameter>
        <ac:parameter ac:name="outline">#{params['outline']}</ac:parameter>
        <ac:parameter ac:name="include">#{params['include']}</ac:parameter>
      </ac:structured-macro>
      TOC
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
      value = []
      value << "<p>#{@notice}</p>" if @notice
      value << toc if @toc
      value << Kramdown::Document.new(markdown, options).to_html
      value.join("\n")
    end
  end
end
