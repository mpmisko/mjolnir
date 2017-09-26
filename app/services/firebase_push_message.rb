require 'fcm'
require 'firebase_client.rb'

module MessagingService
  class FirebasePushMessage
    attr_accessor :id, :response

    def initialize(id, response)
      @id = id
      @response = response
    end

    def send
      client = fcm
      answer = client.send([@id.to_s], options(@response))
      Rails.logger.info "Firebase answer: #{answer.to_s}"
      answer
    end

    private

    def options(response)
      {
        priority: 'high',
        data: {
          event: 'call_results',
          data: response
        }
      }
    end

    def firebase_notification_text
      @text ||= 'The results from your call arrived!'
    end

    def fcm
      ClientBuilder::FirebaseClient.client
    end
  end
end
