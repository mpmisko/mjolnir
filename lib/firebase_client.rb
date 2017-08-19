require 'fcm'

module ClientBuilder
  class FirebaseClient
    def self.client
      @fcm ||= FCM.new(ENV['FIREBASE_TOKEN'])
    end
  end
end
