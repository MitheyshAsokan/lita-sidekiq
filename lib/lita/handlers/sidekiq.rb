require 'sidekiq'

# If your client is single-threaded, we just need a single connection in our Redis connection pool
Sidekiq.configure_client do |config|
  config.redis = {db: 1}
end

# Sidekiq server is multi-threaded so our Redis connection pool size defaults to concurrency (-c)
Sidekiq.configure_server do |config|
  config.redis = {db: 1}
end

 

module Lita
  module Handlers

    class Sidekiq < Handler
      route(/^echo\s+(.+)/, :echo)

      def echo(response)
        resp = response.matches[0][0].to_s
        Worker.perform_async(resp)
        #response.reply(response.matches)
      end

      Lita.register_handler(self)
    end
  end
end


class Worker
  include Sidekiq::Worker
end 