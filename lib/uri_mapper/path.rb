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
        @raw_path = source.to_s

        # take care of the leading "/"
        if @raw_path.length > 0 and @raw_path[0] != '/'
          @raw_path = "/#{@raw_path}"
        end
      end
    end

    def parts
      @parts ||= @raw_path.gsub(/^\//, '').split('/')
    end

    def [](index)
      parts[index]
    end

    def []=(index, value)
      parts[index] = value
    end

    def each(&block)
      parts.each(&block)
    end

    def merge!(other)
      other = self.class.build(other)
      @parts = parts + other.parts
      self
    end

    def to_s
      if @parts
        # then we've accessed it once, use that as source
        '/' + @parts.join('/')
      else
        # untouched, just return the old one
        @raw_path
      end
    end

    def serialize
      string = to_s

      if string != '/'
        string
      else
        ''
      end
    end
  end
end
