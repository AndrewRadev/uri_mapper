require 'uri'
require 'request_mapper/query'

module RequestMapper
  class Uri
    def initialize(string)
      @uri = URI.parse(string)
    end

    def query
      @query ||= Query.new(@uri.query)
    end

    def query=(v)
      @query = v
    end

    def map(component, &block)
      Uri.new(@uri.to_s).map!(component, &block)
    end

    def map!(component)
      case component.to_sym
      when :query
        @uri.query = yield query
      else
        raise "Unknown URI component: #{component}"
      end

      self
    end

    def to_s
      uri = @uri.dup
      uri.query = query.to_s
      uri.to_s
    end
  end
end
