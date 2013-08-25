require 'set'

# Note: expects @components in the including class.
# TODO (2013-08-25) Make this more explicit sommehow?
# TODO (2013-08-25) Double-check class variable inheritance magic
#
module UriBuilder
  # Defines a new URI component, generating needed accessors

  @@component_names = Set.new

  def component_names
    @@component_names
  end

  def component(component_name, options = {}, &block)
    dependent_components = options[:depends] || []

    @@component_names << component_name

    define_method(component_name) do
      @components[component_name] ||= instance_eval(&block)
    end

    define_method("#{component_name}=") do |value|
      self.public_send(component_name).reload(value)

      dependent_components.each do |component_name|
        @components[component_name] = nil
      end
    end
  end
end
