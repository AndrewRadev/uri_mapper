module UriMapper
  class Component
    def self.build(source)
      if source.is_a?(self)
        source
      else
        new(source)
      end
    end

    def initialize(*)
      raise NotImplementedError
    end

    def merge(other)
      copy = dup
      copy.merge!(other)
      copy
    end

    def merge!(other)
      raise NotImplementedError
    end

    def ==(other)
      to_s == other.to_s
    end
  end
end
