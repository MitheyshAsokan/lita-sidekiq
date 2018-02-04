require 'sidekiq'
require 'lita'

# If your client is single-threaded, we just need a single connection in our Redis connection pool
Sidekiq.configure_client do |config|
  config.redis = {db: 1}
end

# Sidekiq server is multi-threaded so our Redis connection pool size defaults to concurrency (-c)
Sidekiq.configure_server do |config|
  config.redis = {db: 1}
end

class Worker
  include Sidekiq::Worker
  include Lita::Handlers

  def perform(complexity)
    sleep 4
    puts "something happened: " + complexity
    #complexity.reply("hello")
    #Response.reply(say)
  end
end  