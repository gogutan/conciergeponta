class ChatLog < ApplicationRecord
  enum role: {
    user: 0,
    assistant: 1,
  }
end
