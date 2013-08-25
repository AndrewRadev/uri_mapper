require 'uri'
require 'uri_mapper/uri_builder'
require 'uri_mapper/query'
require 'uri_mapper/subdomains'

module UriMapper
  class Uri
    extend UriBuilder

    component :host, :depends => [:subdomains] do
      (subdomains.to_a + domains.raw).join('.')
    end

    component :domains, :depends => [:host] do
      @uri.host.split('.').last(2)
    end

    component :subdomains, :class => Subdomains, :depends => [:host] do
      @uri.host
    end

    component :query, :class => Query do
      Query.build(@uri.query)
    end

    def initialize(string)
      @components = {}
      @uri        = URI.parse(string)
    end

    def map(component = nil, &block)
      Uri.new(@uri.to_s).map!(component, &block)
    end

    alias_method :change, :map

    def get(component_name)
      if self.class.component_names.include?(component_name)
        public_send(component_name)
      else
        raise "Unknown component: #{component_name}"
      end
    end

    def set(component_name, replacement)
      get(component_name).reload(replacement)
    end

    def map!(component = nil)
      # No component requested, just yield the whole thing
      if not component
        yield self
        return self
      end

      # Components with static changes, just merge them in
      if component.is_a? Hash
        component.each do |name, replacement|
          set(name, replacement)
        end

        return self
      end

      # Component and a block
      replacement = yield get(component)
      set(component, replacement)

      self
    end

    alias_method :change!, :map!

    def to_s
      uri = @uri.dup

      uri.query = query.to_s
      uri.host  = host.to_s

      uri.to_s
    end
  end
end
