# frozen_string_literal: true

module Clients
  class BaseRequest
    class << self
      def request(http_method, url, params = {}, auth_info = {})
        new(url, params, auth_info).send("request_url_#{http_method}")
      end
    end

    attr_reader :url, :params, :auth_info

    delegate :base_uri, :version_part, to: :config

    def initialize(url, params, auth_info)
      @url = url
      @params = params
      @auth_info = auth_info
      setup_default_config_url!
    end

    def request_url_get
      conn.get url do |req|
        req.params = params
        req.headers = headers_params
      end
    end

    def request_url_post
      conn.post url do |req|
        req.headers = headers_params
        req.body = params
      end
    end

    def conn
      @conn ||= ::Faraday.new(url: "#{base_uri}#{version_part}") do |conn|
        conn.request :multipart
        conn.request :url_encoded
        conn.adapter :net_http
      end
    end

    def setup_default_config_url!
      raise NotImplementedError, 'Implement setup_default_config_url! method in subclass'
    end

    def config
      @config ||= OpenStruct.new
    end

    def headers_params
      raise NotImplementedError, 'Implement headers_params method in subclass'
    end
  end
end
