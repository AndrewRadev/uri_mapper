require 'uri'
require 'uri_mapper/abstract_uri'
require 'uri_mapper/components'

# TODO (2013-08-25) Make a testing plan, this'll get complicated
#
module UriMapper
  class Uri < AbstractUri
    # TODO (2013-08-25) alias_component, use both :scheme and :protocol
    # TODO (2013-11-24) raw_component that just uses strings
    component :scheme, :core => true
    component :path,   :core => true, :class => Components::Path
    component :query,  :core => true, :class => Components::Query

    component :subdomains, :class => Components::Subdomains, :depends => [:host]

    component :host, :core => true, :depends => [:subdomains, :domains] do
      (subdomains.to_a + domains.raw).join('.')
    end

    # TODO (2013-11-26) accesses @core. Need to find a way to avoid that
    component :domains, :depends => [:host] do
      @core.host.split('.').last(2)
    end
  end
end
