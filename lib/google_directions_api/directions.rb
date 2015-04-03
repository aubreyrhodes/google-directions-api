require 'faraday'
require 'json'

module GoogleDirectionsAPI
  class Directions
    attr_accessor :to
    attr_accessor :from

    def self.new_for_locations(from:, to:)
      new.tap do |d|
        d.to = to
        d.from = from
      end
    end

    def distance
      meters = data["routes"][0]["legs"][0]["distance"]["value"]
      (meters / 1000) * 0.621371
    end

    private

    def response
      conn = Faraday.new(url: 'https://maps.googleapis.com')
      @response ||= conn.get "/maps/api/directions/json?origin=#{from}&destination=#{to}&key=#{ENV['GOOGLE_API_KEY']}"
    end

    def data
      @data ||= JSON.parse(response.body)
    end
  end
end