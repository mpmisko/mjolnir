require 'json'
require 'api-ai-ruby'
require 'api_client.rb'

module MessagingService
  # Service for ai communication.
  class AiMessage
    attr_accessor :sentences, :responses

    MAX_QUERY_LENGHT = 200

    def initialize(call)
      @sentences = JSON.parse(call.content)
      @responses = []
    end

    def send_patch
      @sentences.each do |sentence|
        split_sentences = split(sentence)
        split_responses = []
        split_sentences.each do |split_sentence|
          split_responses << api_client.text_request(split_sentence)
        end
        @responses << join_responses(split_responses)
      end
      @responses
    end

    private

    def api_client
      ClientBuilder::APIClient.client
    end

    def split(text)
      split_arr = text.scan(/.{#{MAX_QUERY_LENGHT}}/)
      left_text_len = text.length % MAX_QUERY_LENGHT
      split_arr << text.split(//).last(left_text_len).join
      split_arr
    end

    def join_responses(ai_responses)
      return ai_responses[0] if ai_responses.length == 1
      useful_response = ai_responses.detect { |ai_response| useful?(ai_response) }
      return ai_responses[0] if useful_response.nil?
      ai_responses.each do |ai_response|
        next if ai_response == useful_response || !useful?(ai_response)
        ai_response.dig(:result, :parameters).each do |type, content|
          useful_response.dig(:result, :parameters)[type] += content unless content.empty?
        end
      end
      useful_response
    end

    def useful?(response)
      return false if response.dig(:result, :parameters).nil?
      true
    end
  end
end
