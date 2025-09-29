# frozen_string_literal: true

require "date"

module CaienaOpenweathermapSdk
  class OpenweathermapError < StandardError; end

  class ClientError < StandardError; end

  # Client to request the Open Weather API service
  class Client
    # initialize a new CaienaOpenweathermapSdk::Client
    # @param base_url for open weather API
    def initialize(base_url)
      @base_url = base_url
    end

    # current_temperature reads the current temperature data from open weather
    # @param location should be string <city>
    # @param appid should be a access key generated at open weather
    # @return current temperature for the given location
    def current_temperature(location, appid)
      uri = URI.parse("#{@base_url}/data/2.5/weather?q=#{location}&units=metric&appid=#{appid}")

      begin
        response = Net::HTTP.get_response(uri)
        body = JSON.parse(response.body)
      rescue StandardError => e
        raise ClientError, e.message
      end

      raise OpenweathermapError, body["message"] || "unknown error" unless response.is_a? Net::HTTPSuccess

      body["main"]["temp"]
    end

    # forecast reads the forecast data from open weather
    # @param location should be string <city>
    # @param appid should be a access key generated at open weather
    # @return average forecast by day for the given location
    def forecast(location, appid)
      uri = URI.parse("#{@base_url}/data/2.5/forecast?q=#{location}&units=metric&appid=#{appid}")

      begin
        response = Net::HTTP.get_response(uri)
        body = JSON.parse(response.body)
      rescue StandardError => e
        raise ClientError, e.message
      end

      raise OpenweathermapError, body["message"] || "unknown error" unless response.is_a? Net::HTTPSuccess

      body["list"].group_by { |f| Date.parse(f["dt_txt"]).to_date.to_s }
                  .transform_values { |entries| (entries.sum { |e| e["main"]["temp"] } / entries.size).round(2) }
    end
  end
end
