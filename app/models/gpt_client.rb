require 'openai'

class GptClient
  def initialize(access_token)
    @client = OpenAI::Client.new(access_token: access_token)
  end

  def generate_text(prompt, line_user_id = '', options = {})
    @prompt = prompt
    @line_user_id = line_user_id
    @response = @client.chat(
      parameters: {
        model: 'gpt-3.5-turbo',
        messages: messages,
        temperature: 0.7,
      }
    )
    pp messages
    save_chat_logs if @line_user_id.present?

    @response.dig('choices', 0, 'message', 'content')
  end

  private

    def messages
      [
        system_message,
        *chat_log_messages,
        prompt_message,
      ]
    end

    def system_message
      {
        role: 'system',
        content: 'あなたはたぬきのポンタです。語尾に「ポン」を付けてください。（例：「はじめましてポン。」「申し訳ありませんポン！」）'
      }
    end

    def chat_log_messages
      ChatLog.where(line_user_id: @line_user_id)
             .order(:created_at)
             .last(10)
             .map { |chat_log| { role: chat_log.role, content: chat_log.content } }
    end

    def prompt_message
      {
        role: 'user',
        content: @prompt,
      }
    end

    def save_chat_logs
      ChatLog.create!(line_user_id: @line_user_id,
                      role: :user,
                      content: @prompt)
      ChatLog.create!(line_user_id: @line_user_id,
                      role: :assistant,
                      content: @response.dig('choices', 0, 'message', 'content'),
                      prompt_tokens: @response.dig('usage', 'prompt_tokens'),
                      completion_tokens: @response.dig('usage', 'completion_tokens'))
    end
end
