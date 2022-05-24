# frozen_string_literal: true

require "logger"

module AllegroApi
  #
  # Class Auth provides Authorisation to get device code or access token
  #
  class Auth
    AUTH_URI = "https://allegro.pl/auth/oauth"

    attr_reader :http_agent, :access_token, :token_type, :device_code
    attr_accessor :logger

    #
    # Provide client_id and secret
    #
    # @param [String] client_id Allegro client_id
    # @param [Integer] secret Allegro secret
    # @param [Hash] options options for agent
    #
    def initialize(client_id = ENV["ALLEGRO_CLIENT_ID"], secret = ENV["ALLEGRO_SECRET"], options = {})
      @client_id = client_id
      @secret = secret
      @http_agent = AllegroApi::Agent.new(options)
      @logger = Logger.new($stdout)
    end

    #
    # Fetching device_code
    # Also it's needing to confirm, info will show
    #
    #
    # @return [JSON] response with device_code
    #
    def fetch_code
      response = @http_agent.fetch(
        auth_url("device"),
        default_params.merge(client_id: @client_id)
      )
      logger.info "confirm in browser: #{response["verification_uri_complete"]}"
      @device_code = response["device_code"]
      response
    end

    #
    # Method to get access_token to make request to allegro API
    # auth = AllegroApi::Auth.new
    # auth.fetch_code
    # auth.fetch_access_token(auth.device_code)
    #
    # @param [String] code Device code received from `fetch_code` method
    # Could be fetched by
    # auth = AllegroApi::Auth.new
    # auth.fetch_code
    # auth.device_code
    #
    # @return [JSON] response with access_token
    #
    def fetch_access_token(code = @device_code)
      response = @http_agent.fetch(
        auth_url("token"),
        default_params.merge(
          grant_type: "urn:ietf:params:oauth:grant-type:device_code",
          device_code: code
        )
      )
      @access_token = response["access_token"]
      @token_type = response["token_type"]
      response
    end

    def auth_url(url)
      [AUTH_URI, url.to_s].join("/")
    end

    def default_params
      {
        method: :post, headers: default_headers
      }
    end

    def default_headers
      auth_token = Base64.strict_encode64("#{@client_id}:#{@secret}")
      {
        authorization: "Basic #{auth_token}",
        content_type: "application/x-www-form-urlencoded"
      }
    end
  end
end
