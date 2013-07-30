require 'uri'
require 'uri_mapper/query'
require 'uri_mapper/subdomains'

module UriMapper
  # TODO (2013-07-10) component list: raw components, wrapped components (dependencies?)
  # TODO (2013-07-29) Different methods for building from URI and from user content
  class Uri
    def initialize(string)
      @uri = URI.parse(string)
    end

    def query
      @query ||= Query.build(@uri.query)
    end

    def query=(v)
      query.reload(v)
    end

    def subdomains
      @subdomains ||= Subdomains.build(@uri.host)
    end

    def subdomains=(v)
      subdomains.reload(v)
      @host = nil
    end

    def host
      @host ||= (subdomains.to_a + domains.to_a).join('.')
    end

    def domains
      @domains ||= @uri.host.split('.').last(2)
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
        component.each do |name, replacement|
          send(name).reload(replacement)
        end

        return self
      end

      # Component and a block
      case component.to_sym
      when :query
        self.query = query.dup.reload(yield query)
      when :subdomains
        self.subdomains = subdomains.dup.reload(yield subdomains)
      else
        raise "Unknown URI component: #{component}"
      end

      self
    end

    def to_s
      uri = @uri.dup

      uri.query = query.to_s
      uri.host  = host.to_s

      uri.to_s
    end
  end
end
