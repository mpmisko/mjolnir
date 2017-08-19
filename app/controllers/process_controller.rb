require 'firebase_push_message.rb'
require 'ai_message.rb'
require 'response_builder.rb'

class CallController < ApplicationController
  def push
    device = Device.get_device(device_params_hash)
    device.calls.create(call_params_hash)
    device_call = Call.find(id)

    ai_message_service = MessagingService::AiMessage.new(device_call)
    Rails.logger.info 'Sending message to API.AI'
    ai_answers = ai_message_service.send_patch
    Rails.logger.info 'Sending message to firebase'
    response = ResponseBuilder.new_phone_response(id, ai_answers)
    device_call.update_attribute(:response, response.to_json)

    firebase_message = MessagingService::FirebasePushMessage
                       .new(device.push_token, response)
    firebase_message.send

    render status: :ok, json: { timestamp: Time.now.to_i.to_s }
  end

  private

  def call_params
    params.permit(:id,
                  :timestamp_start,
                  :timestamp_end,
                  :caller_number,
                  sentences: [])
  end

  def call_params_hash
    { id: id,
      timestamp_call_start: params['timestamp_start'],
      timestamp_call_end: params['timestamp_end'],
      caller_number: params['caller_number'],
      content: params['sentences'].to_s,
      response: 'funny response' }
  end

  def device_params_hash
    { device_uuid: request.headers['device-uuid'],
      push_token: request.headers['firebase-token'],
      user_agent: request.headers['User-Agent'] }
  end

  def id
    params['id']
  end
end
