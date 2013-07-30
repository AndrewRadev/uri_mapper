require 'uri_mapper/component'

module UriMapper
  class Subdomains < Component
    include Enumerable

    def initialize(host)
      if host.is_a? Array
        # it's actually a list of domains
        @subdomains = host
      else
        @subdomains = host.split('.')[0..-3]
      end
    end

    def to_a
      @subdomains
    end

    def each
      to_a.each { |item| yield item }
    end
  end
end
