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
      dup.merge!(other)
    end
    alias_method :+, :merge

    def merge!(other)
      raise NotImplementedError
    end
    alias_method :'+=', :merge!

    def ==(other)
      to_s == other.to_s
    end
  end
end
