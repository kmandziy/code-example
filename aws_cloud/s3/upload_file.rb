# frozen_string_literal: true

module AwsCloud
  module S3
    class UploadFile < Base
      def perform!
        bucket.object(options[:key])
              .upload_file(options[:file], upload_options)
      end

      def upload_options
        {
          metadata: options[:metadata]
        }.compact
      end
    end
  end
end
