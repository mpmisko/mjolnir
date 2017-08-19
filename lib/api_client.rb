require 'api-ai-ruby'

module ClientBuilder
  class APIClient
    def self.client
      @client ||= ApiAiRuby::Client.new(
        client_access_token: ENV['AI_TOKEN'],
        api_base_url: ENV['AI_URL'],
        api_lang: 'EN'
      )
    end
  end
end
