# frozen_string_literal: true

require "net/http"
require "json"
require "base64"
require_relative "allegro_api/version"
require_relative "allegro_api/auth"
require_relative "allegro_api/client"
require_relative "allegro_api/agent"

module AllegroApi
  class Error < StandardError; end
end
