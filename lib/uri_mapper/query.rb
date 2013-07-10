require 'cgi'
require 'rack/utils'

module UriMapper
  class Query
    def initialize(string)
      @raw_query = string
    end

    def query_params
      @query_params ||= Rack::Utils.parse_query(@raw_query)
    end

    def [](k)
      query_params[k.to_s]
    end

    def []=(k, v)
      query_params[k.to_s] = v
    end

    def to_s
      if @query_params
        # then we've accessed it once, use that as source
        build_query(@query_params)
      else
        # untouched, just return the old one
        @raw_query
      end
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
