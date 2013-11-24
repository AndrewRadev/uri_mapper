module UriMapper
  # The skeleton for a URI component, like Query, Path, etc. The underlying
  # implementations can vary, but this class provides the minimal protocol they
  # need to guarantee so the Uri can use them.
  #
  class Component
    def self.build(source)
      if source.is_a?(self)
        source
      else
        new(source)
      end
    end

    # Generates a "relative" value for a component. For the protocol, this
    # would be "//", for a host it would be "", removing the host entirely.
    #
    # TODO (2013-11-24) Should accept a @uri, modify it in some way. Same for
    # reload/initialize/build?
    #
    def self.relative
      raise NotImplementedError
    end

    # The constructor of the Component is called when a component is first
    # accessed by the Uri. It is then initialized with some particular
    # properties of the underlying URI object that are defined by the builder.
    #
    # This may overlap with #reload, but it's not necessarily the case.
    #
    def initialize(*)
      raise NotImplementedError
    end

    # Reloading a component means providing it with the necessary data for it
    # to change its contents.
    #
    # The difference between #reload and #initialize is that this method will
    # not be called by the Uri upon construction, but upon setting by the user,
    # so it's possible that this method will have different concerns than
    # #initialize.
    #
    # For instance, compare:
    #
    #   Query.new('some=query&string')
    #   query.reload(:different => 'format')
    #
    # In practice, it's likely that it will overlap with #initialize, though.
    #
    def reload(*)
      raise NotImplementedError
    end

    # The serialize method is the one that will be used once this component is
    # assigned to the core uri. This tends to be somewhat inconsistent, so it
    # can't be relied only on #to_s to provide a simple serializer.
    #
    def serialize
      raise NotImplementedError
    end

    def merge(other)
      dup.merge!(other)
    end
    alias_method :+, :merge

    # Combines the Component with another component. It's up to the
    # implementation to decide how exactly to treat it, but this should result
    # in an aggregation of the contents of both components.
    #
    # The `other` attribute may not be a Component itself, it's recommended to
    # trigger Component::build on it before working with it.
    #
    def merge!(other)
      raise NotImplementedError
    end
    alias_method :'+=', :merge!

    def ==(other)
      to_s == other.to_s
    end
  end
end
