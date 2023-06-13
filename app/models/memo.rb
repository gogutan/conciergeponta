class Memo < ApplicationRecord
  enum service_type: {
    discord_group: 0,
    discord_dm: 1,
  }
end
