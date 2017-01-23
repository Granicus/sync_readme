require 'json'
require 'faraday'

module SyncReadme
  class ConfluenceSync
    def initialize(config)
      @page_id = config.page_id
      @client = Faraday.new(url: config.url) do |faraday|
        faraday.request  :url_encoded
        # faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter # make requests with Net::HTTP
        faraday.basic_auth(config.username, config.password)
      end
    end

    def update_page_content(content)
      page = get_page
      update(updated_page_params(page, content))
    end

    def get_page
      response = @client.get("/rest/api/content/#{@page_id}", expand: 'body.view,version')
      JSON.parse(response.body)
    end

    def update(params)
      response = @client.put do |request|
        request.url "/rest/api/content/#{@page_id}"
        request.headers['Content-Type'] = 'application/json'
        request.body = params.to_json
      end
    end

    def updated_page_params(page, new_content)
      {
        version: {
          number: increment_version(page),
          minorEdit: true
        },
        title: page['title'],
        type: 'page',
        body: {
          storage: {
            value: new_content,
            representation: 'storage'
          }
        }
      }
    end

    def increment_version(page)
      page['version']['number'] + 1
    end
  end
end
