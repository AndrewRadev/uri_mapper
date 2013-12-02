require 'set'
require 'uri_mapper/components'

module UriMapper
  # Defines a new URI component, generating needed accessors
  #
  # Expects the parent to respond to #core
  #
  # TODO (2013-11-26) Test
  class AbstractUri
    class << self
      def component_names
        @component_names ||= Set.new
      end

      def core_component_names
        @core_component_names ||= Set.new
      end

      def component(component_name, options = {}, &block)
        depends = options[:depends] || []
        klass   = options[:class]   || Components::Simple
        is_core = options[:core]

        # TODO (2013-11-26) This'll be removed when components are just given the full URI
        if block.nil? and depends.length == 1
          block = lambda { |uri| uri.core.public_send(depends.first) }
        elsif block.nil?
          block = lambda { |uri| uri.core.public_send(component_name) }
        end

        component_names      << component_name
        core_component_names << component_name if is_core

        define_method(component_name) do
          @components[component_name] ||= klass.build(instance_eval(&block))
        end

        define_method("#{component_name}=") do |value|
          self.public_send(component_name).reload(value)

          depends.each do |component_name|
            @components[component_name] = nil
          end
        end
      end
    end

    attr_reader :core

    def initialize(string)
      @core = parse_uri(string)
      @components = {}
    end

    def parse_uri(string)
      URI.parse(string)
    end

    def dup
      self.class.new(@core.to_s)
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
      update_uri(@core.dup).to_s
    end

    private

    def update_uri(uri)
      self.class.core_component_names.each do |name|
        uri.public_send("#{name}=", get(name).serialize)
      end

      uri
    end
  end
end
