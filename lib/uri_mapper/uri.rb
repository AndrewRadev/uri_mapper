require 'uri'
require 'uri_mapper/uri_builder'
require 'uri_mapper/path'
require 'uri_mapper/query'
require 'uri_mapper/subdomains'

# TODO (2013-08-25) Make a testing plan, this'll get complicated
#
module UriMapper
  class Uri
    include UriBuilder
    extend UriBuilder::ClassMethods

    # TODO (2013-08-25) alias_component, use both :scheme and :protocol
    # TODO (2013-11-24) raw_component that just uses strings
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
      @uri = URI.parse(string)

      initialize_components
    end

    def dup
      Uri.new(@uri.to_s)
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
      dup.map!(component, &block)
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

    def merge(tree = {})
      dup.merge!(tree)
    end

    def merge!(tree = {})
      tree.each do |component_name, addition|
        get(component_name).merge!(addition)
      end

      self
    end

    def relative(*component_names)
      dup.relative!(*component_names)
    end

    def relative!(*component_names)
      component_names.each do |name|
        set(name, get(name).class.relative)
      end
      self
    end

    def to_s
      uri = @uri.dup

      uri.scheme = scheme.serialize
      uri.host   = host.serialize
      uri.path   = path.serialize
      uri.query  = query.serialize

      uri.to_s
    end
  end
end
