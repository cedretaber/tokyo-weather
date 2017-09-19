class WeatherReport

  require "uri"
  require "net/http"
  require "json"

  URL = URI.parse("https://slack.com/api/chat.postMessage").freeze

  def initialize(token, channel)
    @token = token
    @channel = channel
  end

  def post_report(reports)
    args = {
      token: @token,
      channel: @channel,
      text: "天気予報で〜す",
      attachments: reports.to_json,
      icon_emoji: ":haru_chan:",
      username: "春ちゃん"
    }
    Net::HTTP.post_form(URL, args)
  end
end
