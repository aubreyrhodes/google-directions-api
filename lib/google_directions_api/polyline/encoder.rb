module GoogleDirectionsAPI
  module Polyline
    class Encoder
      def self.encode(points, precision = 1e5)
        result = ""
        last_lat = last_lng = 0

        points.each do |point|
          lat = (point[0] * precision).round
          lng = (point[1] * precision).round
          d_lat = lat - last_lat
          d_lng = lng - last_lng
          chunks_lat = encode_number(d_lat)
          chunks_lng = encode_number(d_lng)
          result << chunks_lat << chunks_lng
          last_lat = lat
          last_lng = lng
        end

        result
      end

      private

      def self.encode_number(num)
        sgn_num = num << 1
        sgn_num = ~sgn_num if num < 0
        encode_unsigned_number(sgn_num)
      end

      def self.encode_unsigned_number(num)
        encoded = ""
        while num >= 0x20
          encoded << (0x20 | (num & 0x1f)) + 63
          num = num >> 5
        end
        encoded << num + 63
      end
    end
  end
end
