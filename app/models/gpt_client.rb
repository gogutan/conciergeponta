require 'openai'

class GptClient
  def initialize(access_token)
    @access_token = access_token
    @client = OpenAI::Client.new(access_token: access_token)
  end

  def generate_text(prompt, options = {})
    response = @client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: prompt}],
      temperature: 0.7,
    })
    response.dig("choices", 0, "message", "content")
  end
end
