# frozen_string_literal: true

module Clients
  module Centrifugo
    class Api
      class << self
        delegate :request, to: '::Clients::Centrifugo::Request'

        def publish(channel, data)
          body = {
            method: 'publish',
            params: {
              channel: channel,
              data: data
            }
          }

          JSON.parse request('post', '', JSON.generate(body)).body
        end

        def broadcast(channels, data)
          body = {
            method: 'broadcast',
            params: {
              channels: channels,
              data: data
            }
          }

          JSON.parse request('post', '', JSON.generate(body)).body
        end
      end
    end
  end
end
