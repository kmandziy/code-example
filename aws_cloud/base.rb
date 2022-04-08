# frozen_string_literal: true

module AwsCloud
  class Base
    include ::AwsCloud::ResourceConfig

    attr_reader :options
  end
end
