# frozen_string_literal: true

require "logger"

module AllegroApi
  #
  # Class Agent provides to make get, post requests, handle simple errors and parse result
  #
  class Agent
    attr_accessor :options, :logger

    def initialize(options = {})
      @logger = Logger.new($stdout)
      @options = options
    end

    def fetch(uri, params = {})
      uri = URI(uri)
      body = nil
      begin
        session = Net::HTTP.new(uri.host, uri.port)
        session.use_ssl = uri.scheme == "https"
        response = session.start do |http|
          response, body = make_request(build_request(uri, params), http)
          response
        end

        parsed_body = parse_response(response, body)
      rescue StandardError => e
        logger.error e.message

        raise e
      end
      parsed_body
    end

    protected

    def build_request(uri, params)
      request_params = params.reject { |k, _v| %i[method headers].include?(k) }
      headers = params[:headers]
      request = case params[:method]
                when :get
                  uri.query = URI.encode_www_form(params)
                  Net::HTTP::Get.new(uri.request_uri)
                when :post
                  request = Net::HTTP::Post.new(uri.path)
                  request.set_form_data(request_params)
                  request
                end
      headers.each { |k, v| request[k.to_s] = v }
      request
    end

    def make_request(request, http)
      body = []
      response = begin
        http.request(request) do |resp|
          resp.read_body do |segment|
            body << segment
          end
        end
      rescue StandardError => e
        logger.error e.message
      ensure
        body = body.join
      end

      [response, body]
    end

    def parse_response(response, body)
      case response
      when Net::HTTPSuccess
        parse_body(body, response.content_type)
      when Net::HTTPRedirection
        raise StandardError, response.message
      else
        body = parse_body(body, response.content_type)
        return body if body.is_a?(Hash)

        raise StandardError, response.message
      end
    end

    def parse_body(body, content_type)
      json?(content_type) ? JSON.parse(body) : body
    end

    def json?(content_type)
      !!content_type.match(%r{application/(vnd\.allegro\.public\.v\d+\+json|json)})
    end
  end
end
