require 'uri'
require 'uri_mapper/query'

module UriMapper
  # TODO (2013-07-10) component list: raw components, wrapped components (dependencies?)
  # TODO (2013-07-10) Think about how map/merge should behave for `query`: merge params or override them?
  class Uri
    def initialize(string)
      @uri = URI.parse(string)
    end

    def query
      @query ||= Query.new(@uri.query)
    end

    def query=(v)
      @query = Query.build(v)
    end

    def map(component = nil, &block)
      Uri.new(@uri.to_s).map!(component, &block)
    end

    alias_method :change, :map

    def map!(component = nil)
      # No component requested, just yield the whole thing
      if not component
        yield self
        return self
      end

      # Components with static changes, just merge them in
      if component.is_a? Hash
        if component.keys.length == 1 and component.keys.first == :query
          self.query = Query.build(component[:query])
        else
          raise "Not implemented for different components yet"
        end

        return self
      end

      # Component and a block
      case component.to_sym
      when :query
        self.query = Query.build(yield query)
      when :subdomain
        # TODO (2013-07-10) Implement
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
