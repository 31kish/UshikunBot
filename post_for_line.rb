require 'line/bot'

class PostForLine
  def post(text)
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }

  message = {
    type: 'text',
    text: text
  }

  client.push_message(ENV['LINE_GROUP_ID'], message)
  end
end
