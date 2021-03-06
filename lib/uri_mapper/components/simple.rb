module UriMapper
  module Components
    class Simple < Common
      attr_reader :raw

      def self.build(source)
        if source.is_a?(self)
          source
        else
          new(source)
        end
      end

      def initialize(raw)
        @raw = raw
      end

      def reload(raw)
        @raw = raw
      end

      def merge!(other)
        other = self.class.build(other)
        reload(other.raw)
        self
      end

      def to_s
        @raw.to_s
      end
      alias_method :serialize, :to_s
    end
  end
end
