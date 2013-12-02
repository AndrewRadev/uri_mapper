require 'spec_helper'
require 'uri_mapper/abstract_uri'
require 'uri_mapper/components'

module UriMapper
  describe AbstractUri do
    describe ".component" do
      let(:uri_class) do
        Class.new(AbstractUri) do
          component :host
        end
      end

      let(:uri) { uri_class.new('http://example.com') }

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

      it "can be defined as a 'core' component, which makes it change the core uri" do
        uri_class = Class.new(AbstractUri) do
          component :host
        end
        uri = uri_class.new('http://example.com')
        uri.map(:host => 'changed.com').to_s.should eq 'http://example.com'

        uri_class = Class.new(AbstractUri) do
          component :host, :core => true
        end
        uri = uri_class.new('http://example.com')
        uri.map(:host => 'changed.com').to_s.should eq 'http://changed.com'
      end

      it "can be given a specific class to use for the component" do
        component_class = Class.new do
          def self.build(*)
            new
          end
        end

        uri_class = Class.new(AbstractUri) do
          component :host, :class => component_class
        end

        uri_class.new('http://example.com').host.should be_a component_class
      end
    end

    describe "#parse_uri" do
      it "can be overridden by child classes to change core URI object" do
        uri_class = Class.new(AbstractUri) do
          def parse_uri(string)
            string.upcase
          end
        end

        uri_class.new('foo').core.should eq 'FOO'
      end
    end

    describe "#map" do
      let(:uri_class) do
        Class.new(AbstractUri) do
          component :scheme, :core => true
          component :host,   :core => true
        end
      end

      let(:uri) { uri_class.new('http://example.com') }

      describe "hash form" do
        it "can change a single component" do
          new_uri = uri.map(:host => 'changed.com')
          new_uri.to_s.should eq 'http://changed.com'
        end

        it "can change multiple components" do
          new_uri = uri.map({
            :scheme => 'ftp',
            :host   => 'changed.com',
          })
          new_uri.to_s.should eq 'ftp://changed.com'
        end
      end

      describe "block form" do
        it "can change a single component" do
          new_uri = uri.map(:host) do |h|
            h.to_s.upcase
          end
          new_uri.to_s.should eq 'http://EXAMPLE.COM'
        end

        it "can change multiple components" do
          new_uri = uri.map do |u|
            u.host   = 'changed.com'
            u.scheme = 'ftp'
          end

          new_uri.to_s.should eq 'ftp://changed.com'
        end
      end
    end
  end
end
