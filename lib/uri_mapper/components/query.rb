require 'cgi'
require 'rack/utils'
module UriMapper
  module Components
    class Query < Common
      def initialize(source)
        reload(source)
      end

      def reload(source)
        if source.is_a? Query
          @params = source.to_h
        elsif source.is_a? Hash
          @params = source
        elsif source.respond_to?(:to_query)
          @raw_query = source.to_query
        else
          @raw_query = source.to_s
        end
      end

      def params
        @params ||= Rack::Utils.parse_query(@raw_query)
      end

      def [](k)
        params[k.to_s]
      end

      def []=(k, v)
        params[k.to_s] = v
      end

      # Override
      def merge!(other)
        other = Query.build(other)
        other.params.each { |k, v| params[k.to_s] = v }
        self
      end

      def to_s
        if @params
          # then we've accessed it once, use that as source
          build_query(@params)
        else
          # untouched, just use the old one
          @raw_query
        end
      end

      def serialize
        string = to_s
        string if string != ''
      end

      def to_h
        params
      end

      private

      def build_query(params)
        params.map do |key, value|
          if value.respond_to?(:to_query)
            "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_query)}"
          elsif value.is_a? Array
            value.map do |v|
              build_query("#{key.to_s}[]" => v)
            end
          elsif value.is_a? Hash
            value.map do |subkey, v|
              build_query("#{key.to_s}[#{subkey}]" => v)
            end
          else
            "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
          end
        end.join('&')
      end
    end
  end
end
