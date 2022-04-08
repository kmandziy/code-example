# frozen_string_literal: true

module AwsCloud
  module ResourceConfig
    private

      def config
        @config ||= OpenStruct.new(default_config.merge(options))
      end

      def default_config
        {
          credentials: credentials,
          region: Rails.application.credentials.dig(:aws, :region)
        }
      end

      def credentials
        Aws::Credentials.new(Rails.application.credentials.dig(:aws, :access_key_id),
                             Rails.application.credentials.dig(:aws, :secret_access_key))
      end
  end
end
