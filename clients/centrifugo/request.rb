# frozen_string_literal: true

module Clients
  module Centrifugo
    class Request < ::Clients::BaseRequest
      def headers_params
        {
          Authorization: "apikey #{api_key}",
          'Content-Type' => 'application/json'
        }
      end

      def api_key
        Rails.application.credentials.dig(:centrifugo, :api_key)
      end

      def setup_default_config_url!
        config.base_uri = Rails.application.credentials.dig(:centrifugo, :host)
        config.version_part = '/api'
      end
    end
  end
end
