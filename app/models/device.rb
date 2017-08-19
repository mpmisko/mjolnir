class Device < ApplicationRecord
  has_many :calls, dependent: :destroy

  def self.get_device(info_hash)
    device = find_or_create_by(info_hash.except(:user_agent))
    unless device.user_agent == info_hash[:user_agent]
      device.update_attribute(:user_agent, info_hash[:user_agent])
    end
    device
  end
end
