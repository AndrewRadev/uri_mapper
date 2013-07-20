require 'cgi'
require 'rack/utils'

module UriMapper
  # TODO (2013-07-10) Check if subject to serialize responds to #to_query
  class Query
    def self.build(source)
      if source.is_a?(self)
        source
      else
        new(source)
      end
    end

    def initialize(source)
      if source.is_a? Hash
        @params = source
      else
        @raw_query = source
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

    def merge(other)
      other = Query.new(other) if not other.is_a?(Query)
      @params = params.merge(other.params)
    end

    def to_s
      if @params
        # then we've accessed it once, use that as source
        build_query(@params)
      else
        # untouched, just return the old one
        @raw_query
      end
    end

    def ==(other)
      to_s == other.to_s
    end

    private

    # TODO (2013-07-05) test
    def build_query(params)
      params.map do |key, value|
        if value.is_a? Hash
          "#{CGI.escape(key.to_s)}=#{build_query(value)}"
        else
          "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
        end
      end.join('&')
    end
  end
end
