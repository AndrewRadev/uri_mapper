require 'uri'
require 'uri_mapper/uri_builder'
require 'uri_mapper/path'
require 'uri_mapper/query'
require 'uri_mapper/subdomains'

# TODO (2013-08-25) Consider responsibilities: does Uri split things into
# parts, or does <component>#build ?
#
# TODO (2013-08-25) Make a testing plan, this'll get complicated
#
module UriMapper
  class Uri
    extend UriBuilder

    # TODO (2013-08-25) alias_component, use both :scheme and :protocol
    component :scheme
    component :path, :class => Path
    component :query, :class => Query
    component :subdomains, :class => Subdomains, :depends => [:host]

    component :host, :depends => [:subdomains, :domains] do
      (subdomains.to_a + domains.raw).join('.')
    end

    component :domains, :depends => [:host] do
      @uri.host.split('.').last(2)
    end

    def initialize(string)
      @components = {}
      @uri        = URI.parse(string)
    end

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

    def map(component = nil, &block)
      Uri.new(@uri.to_s).map!(component, &block)
    end

    alias_method :change, :map

    def map!(component = nil)
      if not component
        # No component requested, just yield the whole thing
        yield self
      elsif component.is_a? Hash
        # Components with static changes, just merge them in
        component.each do |name, replacement|
          set(name, replacement)
        end
      else
        # Component and a block
        replacement = yield get(component)
        set(component, replacement)
      end

      self
    end

    alias_method :change!, :map!

    def to_s
      uri = @uri.dup

      uri.scheme = scheme.to_s
      uri.host   = host.to_s
      uri.path   = path.to_s
      uri.query  = query.to_s

      uri.to_s
    end
  end
end
