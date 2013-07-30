require 'uri_mapper/component'

module UriMapper
  class Subdomains < Component
    include Enumerable

    def initialize(host)
      @subdomains = host.split('.')[0..-3]
    end

    def reload(subdomains)
      @subdomains = subdomains
    end

    def to_a
      @subdomains
    end

    def each
      to_a.each { |item| yield item }
    end
  end
end
