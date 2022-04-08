# frozen_string_literal: true

require 'aws-sdk-s3'

module AwsCloud
  module S3
    class Base < ::AwsCloud::Base
      def self.call(bucket_name, options = {})
        new(bucket_name, options).perform!
      end

      private

        attr_reader :bucket_name

        def initialize(bucket_name, options)
          @bucket_name = bucket_name
          @options = options
        end

        def s3
          @s3 ||= ::Aws::S3::Resource.new(client_config)
        end

        def client
          @client ||= ::Aws::S3::Client.new(client_config)
        end

        def client_config
          {
            region: config.region
          }.merge(Hash(dev_config))
        end

        def dev_config
          {
            credentials: config.credentials
          } if Rails.env.development?
        end

        def bucket
          @bucket ||= s3.bucket(bucket_name)
        end

        def perform!
          raise NotImplementedError, 'Implement perform! method in subclass'
        end
    end
  end
end
