require 'id_service.rb'
 
module Calls
  class Call
    attr_reader :params, :remote_id
 
    def initialize(params)
      @params = params
      @remote_id = id_service.generate_id(@params)
    end
   
    def registration_response
      registration_process
    end
 
    private
 
    def id_service
      @service ||= Services::IdService.new
    end
     
    def call_info
      @params[:call]
    end 
 
    def registartion_process
       raise 'Not Implemented'
     end
   end
 end