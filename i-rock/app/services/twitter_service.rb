class TwitterService
  def initialize
    @client = Twitter::REST::Client.new do |c|
      c.consumer_key = ENV["CONSUMER_KEY"]
      c.consumer_secret = ENV["CONSUMER_KEY_SECRET"]
      c.access_token = ENV["ACCESS_TOKEN"]
      c.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
    end
  end

  def tweet(message)
    @client.update(message)
  end
end
