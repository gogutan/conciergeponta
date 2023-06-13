class DiscordBot
  def initialize
    @bot = Discordrb::Bot.new(token: Rails.application.credentials.discord[:token])
  end

  def start
    settings
    @bot.run
  end

  def settings
    @bot.message(start_with: 'add ') do |event|
      body = event.message.content.sub('add ', '')
      Memo.create(service_type: :discord_group, uid: event.channel.id, body: body)
      event.respond "メモに #{body} を追加したポン"
    rescue ActiveRecord::RecordNotUnique => e
      puts e.inspect
      event.respond "既に #{body} は存在するポン"
    end

    @bot.message(start_with: 'sample') do |event|
      sample = Memo.discord_group
                   .where(uid: event.channel.id)
                   .sample
      event.respond "ポン！\n#{sample.body}"
    end

    @bot.message(start_with: 'limit') do |event|
      number = event.message.content.sub('limit ', '').to_i
      memos = Memo.discord_group
                  .where(uid: event.channel.id)
                  .shuffle
                  .take(number)
      pons = 'ポン' * memos.size
      memos_message = memos.map { |memo| "\n#{memo.body}" }.join
      event.respond "#{pons}！#{memos_message}"
    end

    @bot.message(start_with: 'destroy') do |event|
      body = event.message.content.sub('destroy ', '')
      memo = Memo.discord_group
                 .where(uid: event.channel.id)
                 .find_by(body: body)
      if memo&.destroy
        event.respond "メモから #{body} を削除したポン"
      end
    end
  end
end
