require 'spec_helper'
require 'uri_mapper/abstract_uri'
require 'uri_mapper/components'

module UriMapper
  describe AbstractUri do
    describe ".component" do
      class TestUri < AbstractUri
        component :host
      end

      let(:uri) { TestUri.new('http://example.com') }

      it "defines methods to get the given component" do
        uri.host.should eq 'example.com'
        uri.get(:host).should eq 'example.com'
      end

      it "defines methods to set the given component" do
        uri.host = 'foo.com'
        uri.host.to_s.should eq 'foo.com'

        uri.set(:host, 'bar.com')
        uri.host.should eq 'bar.com'
      end
    end
  end
end
