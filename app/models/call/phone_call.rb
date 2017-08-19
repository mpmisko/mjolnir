require 'id_service.rb' 
 
module Calls  
  class PhoneCall < Call
    private

    def timestamp
      Time.now.to_i.to_s
    def

    def registration_process
      { timestamp: timestamp, call: call_info[:local_id], remote_id: @remote_id }
    end
  end
end