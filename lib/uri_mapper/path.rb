require 'cgi'
require 'rack/utils'
require 'uri_mapper/component'

module UriMapper
  class Path < Component
    include Enumerable

    def initialize(source)
      reload(source)
    end

    def reload(source)
      if source.is_a? Path
        @parts = source.to_a
      elsif source.is_a? Array
        @parts = source
      else
        @raw_path = source
      end
    end

    def parts
      @parts ||= @raw_path.split('/')
    end

    def each(&block)
      @parts.each(&block)
    end

    def merge!(other)
      other = self.class.build(other)
      params += other.params
      self
    end

    # TODO (2013-08-25) Escaping?
    def to_s
      if @parts
        # then we've accessed it once, use that as source
        @parts.join('/')
      else
        # untouched, just return the old one
        @raw_path
      end
    end
  end
end
