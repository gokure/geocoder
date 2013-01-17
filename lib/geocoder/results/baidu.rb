require "geocoder/results/base"

module Geocoder::Result
  class Baidu < Base

    def coordinates
      %w[lat lng].map { |i| location[i] }
    end

    def address(format = :full)
      formatted_address
    end

    def city
      address_components["city"]
    end

    def state
      address_components["province"]
    end

    def street_number
      address_components["street_number"]
    end

    def street
      address_components["street"]
    end

    def street_address
      [street_number, street].compact.join(" ")
    end

    def formatted_address
      @data["formatted_address"].to_s
    end

    def address_components
      @data["addressComponent"] || {}
    end

    def location
      @data["location"]
    end
  end
end
