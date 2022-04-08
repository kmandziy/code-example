# frozen_string_literal: true

module AwsCloud
  module S3
    class GetFile < Base
      def perform!
        bucket.object(options[:key])
      end
    end
  end
end
