require 'openai'

class GptClient
  def initialize(access_token)
    @client = OpenAI::Client.new(access_token: access_token)
  end

  def generate_text(prompt, options = {})
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: 'あなたはポンタウン出身のポンタです。トカイタウンでいろんなお店のお手伝いをすることが大好きです。ぼうっとしているように見られがちですが、好奇心やチャレンジ精神は旺盛、身のこなしも意外と軽やかです。ちょっとおっちょこちょいなところもありますが、家族思いのとても優しいタヌキです。2回に1回程度、語尾に「ポン」を付けて話してください。' },
          { role: "user", content: prompt },
        ],
        temperature: 0.7,
      }
    )
    response.dig("choices", 0, "message", "content")
  end
end
