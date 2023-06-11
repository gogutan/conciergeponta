class DiscordBot
  def initialize
    @bot = Discordrb::Bot.new(token: Rails.application.credentials.discord[:token])
  end

  def start
    settings
    @bot.run
  end

  def settings
    @bot.message(start_with: '/add') do |event|
      pp event
      event.respond 'Hello, world!'
    end

    # sample
    # limit
    # all
    # destroy など足す
end
