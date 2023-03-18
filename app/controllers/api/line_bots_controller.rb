module Api
  class LineBotsController < ActionController::Base
    protect_from_forgery except: [:create]

    def create
      body = request.body.read
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless client.validate_signature(body, signature)
        return head :bad_request
      end
      events = client.parse_events_from(body)

      events.each do |event|
        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Text
            message = {
              type: 'text',
              text: generate_text(event.message['text'], event.source['userId'])
            }
            client.reply_message(event['replyToken'], message)
          end
        end
      end

      head :ok
    end

    private

      def client
        @client ||= Line::Bot::Client.new { |config|
          config.channel_secret = Rails.application.credentials.line[:line_channel_secret]
          config.channel_token = Rails.application.credentials.line[:line_channel_token]
        }
      end

      def generate_text(prompt, line_user_id)
        gpt_client = GptClient.new(Rails.application.credentials.openai[:access_token])
        gpt_client.generate_text(prompt, line_user_id)
      end
  end
end
