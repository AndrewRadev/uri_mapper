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

    def initialize
      @components = {}
    end

    def update_uri(uri)
      self.class.core_component_names.each do |name|
        uri.public_send("#{name}=", get(name).serialize)
      end

      uri
    end
  end
end
