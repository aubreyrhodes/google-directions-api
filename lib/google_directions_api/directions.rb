require_relative './base'
require_relative './polyline/encoder'

module GoogleDirectionsAPI
  class Directions < Base
    attr_accessor :from, :to, :waypoints, :departure_time

    def self.new_for_locations(from:, to:, waypoints: nil, departure_time: nil)
      new.tap do |d|
        d.to = to
        d.from = from
        d.waypoints = waypoints
        d.departure_time = departure_time
      end
    end

    def polyline
      data["routes"][0]["overview_polyline"]["points"]
    end

    def distance
      total_distance * 0.000621371
    end

    def duration
      total_duration / 60
    end

    def duration_in_traffic
      return nil unless departure_time.present?
      summed_duration = total_duration_in_traffic
      summed_duration.nil? ? nil : summed_duration / 60
    end

    def has_tolls?
      tolls_along_route?
    end

    private

    def response
      @response ||= get "/maps/api/directions/json", request_params
    end

    def request_params
      {
        origin: from,
        destination: to,
        waypoints: encode_waypoints,
        departure_time: departure_time
      }.keep_if { |k,v| valid_param(v) }
    end

    def valid_param(param)
      !param.nil? && (param.class == ::String ? !param.empty? : param.present?)
    end

    def encode_waypoints
      return unless waypoints_present?
      "enc:#{GoogleDirectionsAPI::Polyline::Encoder.encode(waypoints)}:"
    end

    def data
      @data ||= JSON.parse(response.body)
    end

    def total_distance
      data["routes"][0]["legs"].inject(0) do |meters, leg|
        meters + leg["distance"]["value"]
      end
    end

    def total_duration
      data["routes"][0]["legs"].inject(0) do |seconds, leg|
        seconds + leg["duration"]["value"]
      end
    end

    def total_duration_in_traffic
      summed_duration = data['routes'][0]['legs'].inject(0) do |seconds, leg|
        leg['duration_in_traffic'].nil? ? seconds : seconds + leg['duration_in_traffic']['value']
      end
      return nil if summed_duration == 0
      summed_duration
    end

    def tolls_along_route?
      data["routes"][0]["legs"].each do |leg|
        if leg["steps"].any? { |x| x["html_instructions"].try(:downcase).try(:include?, 'toll road') }
          return true
        end
      end

      false
    end

    def waypoints_present?
      return false if waypoints.nil? || waypoints.empty?

      return true
    end
  end
end
