# frozen_string_literal: true

module AwsCloud
  module S3
    class CopyObject < Base
      def perform!
        client.copy_object(
          bucket: bucket_name,
          copy_source: options[:source_bucket_name],
          key: options[:key],
          metadata: options[:metadata],
          metadata_directive: 'REPLACE'
        )
      end
    end
  end
end
