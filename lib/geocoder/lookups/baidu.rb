require "geocoder/lookups/base"
require "geocoder/results/baidu"

module Geocoder::Lookup
  class Baidu < Base

    def name
      "Baidu"
    end

    def map_link_url(coordinates)
      "http://api.map.baidu.com/geocoder?location=#{coordinates.join(',')}&coord_type=gcj02&output=html"
    end

    def required_api_key_parts
      ["key"]
    end

    def query_url(query)
      "#{protocol}://api.map.baidu.com/geocoder?" + url_query_string(query)
    end

    private

    def results(query)
      return [] unless doc = fetch_data(query)
      case doc["status"]; when "OK" # OK status implies >0 results
        return [doc["results"]]
      when "INVILID_KEY"
        raise_error(Geocoder::InvalidApiKey) ||
          warn("Baidu Geocoding API error: invalid API key.")
      when "INVALID_PARAMETERS"
        raise_error(Geocoder::InvalidRequest) ||
          warn("Baidu Geocoding API error: invalid request.")
      end
      return []
    end

    def query_url_params(query)
      {
        :output => "json",
        :key => configuration.api_key,
        (query.reverse_geocode? ? :location : :address) => query.sanitized_text
      }.merge(super)
    end
  end
end
