require 'set'
require 'uri_mapper/simple_component'

module UriMapper
  module UriBuilder
    # Defines a new URI component, generating needed accessors

    def initialize_components
      @components = {}
    end

    module ClassMethods
      @@component_names = Set.new

      def component_names
        @@component_names
      end

      def component(component_name, options = {}, &block)
        depends = options[:depends] || []
        klass   = options[:class]   || SimpleComponent

        if block.nil? and depends.length == 1
          block = lambda { |context| @uri.public_send(depends.first) }
        elsif block.nil?
          block = lambda { |context| @uri.public_send(component_name) }
        end

        @@component_names << component_name

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
  end
end
