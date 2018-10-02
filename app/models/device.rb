class Device < ApplicationRecord
  has_many :calls, dependent: :destroy

  def self.get_device(info_hash)
    device = find_or_create_by(device_uuid: info_hash[:device_uuid])

    # auto-update push_token and user_agent/Users/michal/dev/summapp/mjolnir/app/models/device.rb
    unless device.user_agent == info_hash[:user_agent]
      device.update_attribute(:user_agent, info_hash[:user_agent])
    end
    unless device.push_token == info_hash[:push_token]
      device.update_attribute(:push_token, info_hash[:push_token])
    end
    device
  end
end
