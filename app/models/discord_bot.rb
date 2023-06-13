class DiscordBot
  def initialize
    @bot = Discordrb::Bot.new(token: Rails.application.credentials.discord[:token])
  end

  def start
    settings
    @bot.run
  end

  def settings
    @bot.message do |event|
      bodies = event.message.content.split(/\s|　/)
      command = bodies.shift

      if command.in? %w[a add]
        bodies.each do |body|
          Memo.create(service_type: :discord_group, uid: event.channel.id, body: body)
          event.respond "メモに #{body} を追加したポン"
        rescue ActiveRecord::RecordNotUnique => e
          puts e.inspect
          event.respond "既に #{body} は存在するポン"
        end
      elsif command.in? %w[s sample]
        sample = Memo.discord_group
                     .where(uid: event.channel.id)
                     .sample
        event.respond "ポン！\n#{sample.body}"
      elsif command.in? %w[l limit]
        number = bodies.first.to_i
        memos = Memo.discord_group
                    .where(uid: event.channel.id)
                    .shuffle
                    .take(number)
        pons = 'ポン' * memos.size
        memos_message = memos.map { |memo| "\n#{memo.body}" }.join
        event.respond "#{pons}！#{memos_message}"
      elsif command.in? %w[all]
        memos = Memo.discord_group
                    .where(uid: event.channel.id)
        pons = 'ポン' * memos.size
        memos_message = memos.map { |memo| "\n#{memo.body}" }.join
        event.respond "#{pons}！#{memos_message}"
      elsif command.in? %w[d destroy]
        bodies.each do |body|
          memo = Memo.discord_group
                     .where(uid: event.channel.id)
                     .find_by(body: body)
          if memo&.destroy
            event.respond "メモから #{body} を削除したポン"
          end
        end
      elsif command.in? %w[d_all destroy_all]
        Memo.discord_group
            .where(uid: event.channel.id)
            .destroy_all
        event.respond "メモを全て削除したポン"
      end
    end
  end
end
