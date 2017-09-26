require 'firebase_push_message.rb'
require 'ai_message.rb'
require 'response_builder.rb'

class CallController < ApplicationController
  def push
    # create device and call
    device = Device.get_device(device_params_hash)
    device.calls.create(call_params_hash)
    device_call = Call.find(id)

    # send ai request
    ai_answers = send_ai_message(device_call)

    # store response
    response = ResponseBuilder.new_phone_response(id, ai_answers)
    device_call.update_attribute(:response, response.to_json)

    # send firebase request
    firebase_answer = send_firebase_message(device, response)

    if firebase_success?(firebase_answer)
      render status: :ok, json: { timestamp: Time.now.to_i.to_s }
    else
      render status: :unathorized, json: { message: 'invalid firebase token' }
    end
  rescue ActiveRecord::RecordNotUnique
    render status: :internal_server_error,
           json: { message: 'duplicate call id' }
  end

  private

  def call_params
    params.permit(:id,
                  :timestamp_start,
                  :timestamp_end,
                  :caller_number,
                  :receiver_number,
                  sentences: [])
  end

  def call_params_hash
    { id: id,
      timestamp_call_start: params['timestamp_start'],
      timestamp_call_end: params['timestamp_end'],
      caller_number: params['caller_number'],
      receiver_number: params['receiver_number'],
      content: params['sentences'].to_s,
      response: 'response not received' }
  end

  def device_params_hash
    { device_uuid: request.headers['device-uuid'],
      push_token: request.headers['firebase-token'],
      user_agent: request.headers['User-Agent'] }
  end

  def id
    params['id']
  end

  def firebase_success?(firebase_answer)
    return false if JSON.parse(firebase_answer.dig(:body)).dig('failure') == 1
    true
  end

  def send_ai_message(device_call)
    ai_message_service = MessagingService::AiMessage.new(device_call)
    Rails.logger.info 'Sending message to API.AI'
    ai_answers = ai_message_service.send_patch
    ai_answers
  end

  def send_firebase_message(device, response)
    firebase_message = MessagingService::FirebasePushMessage
                       .new(device.push_token, response)
    firebase_answer = firebase_message.send
    firebase_answer
  end
end
