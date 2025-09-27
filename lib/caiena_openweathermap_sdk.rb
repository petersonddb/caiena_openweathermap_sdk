# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

require "caiena_openweathermap_sdk/client"

# CaienaOpenweathermapSdk for Open Weather Map API access
module CaienaOpenweathermapSdk
  class << self
    # new CaienaOpenweathermapSdk::client for the API
    # @param base_url for open weather API
    def new(base_url)
      CaienaOpenweathermapSdk::Client.new base_url
    end
  end
end
