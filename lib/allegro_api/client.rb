# frozen_string_literal: true

require "logger"

module AllegroApi
  API_URI = "https://api.allegro.pl"

  #
  # Class Client provides client to make get and post requests
  #
  class Client
    attr_reader :http_agent
    attr_accessor :logger

    def initialize(access_token, token_type = "bearer", options = {})
      @http_agent = AllegroApi::Agent.new(options)
      @logger = Logger.new($stdout)
      @access_token = access_token
      @token_type = token_type
    end

    def get(resource, params = {})
      @http_agent.fetch(
        api_url(resource), default_params.merge(params)
      )
    end

    def post(resource, params)
      @http_agent.fetch(
        api_url(resource), { headers: default_headers, method: :post }.merge(params)
      )
    end

    def search(params)
      @http_agent.fetch(
        api_url("offers/listing"), default_params.merge(params)
      )
    end

    def api_url(url)
      [API_URI, url.to_s].join("/")
    end

    def default_params
      {
        method: :get, headers: default_headers
      }
    end

    def default_headers
      {
        accept: "application/vnd.allegro.public.v1+json",
        authorization: "#{@token_type} #{@access_token}"
      }
    end
  end
end
