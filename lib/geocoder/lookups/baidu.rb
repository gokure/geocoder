require "geocoder/lookups/base"
require "geocoder/results/baidu"
module Geocoder::Lookup
  class Baidu < Base

    def name
      "Baidu"
    end

    def required_api_key_parts
      ["ak"]
    end

    def query_url(query)
      "#{protocol}://api.map.baidu.com/geocoder/v2/?" + url_query_string(query)
    end

    private

      def results(query)
        return [] unless doc = fetch_data(query)
        case doc["status"]
        when 0
          [doc["result"]]
        when 2
          raise_error(Geocoder::InvalidRequest) ||
            warn("Baidu Geocoding API error: invalid request.")
        when 5
          raise_error(Geocoder::InvalidApiKey) ||
            warn("Baidu Geocoding API error: invalid API key.")
        else
          []
        end
      end

      def query_url_params(query)
        {
          :output => "json",
          :ak => configuration.api_key,
          (query.reverse_geocode? ? :location : :address) => query.sanitized_text
        }.merge(super)
      end
  end
end
