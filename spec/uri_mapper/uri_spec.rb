require 'spec_helper'
require 'uri_mapper/uri'

module UriMapper
  describe Uri do
    describe "#host" do
      let(:uri) { Uri.new('http://www.example.com/path?query') }

      it "can be retrieved" do
        uri.host.should eq 'www.example.com'
      end

      it "can be changed" do
        uri.host = 'changed.org'
        uri.to_s.should eq 'http://changed.org/path?query'
      end
    end

    describe "#map" do
      let(:uri) { Uri.new('http://example.com?search=foo') }

      it "allows modification of the entire uri" do
        new_uri = uri.map { |u| u.query['search'] = 'bar' }
        new_uri.to_s.should eq 'http://example.com?search=bar'
      end
    end

    describe "#map(:subdomains)" do
      let(:uri) { Uri.new('http://example.com') }

      it "sets additional subdomains" do
        new_uri = uri.map(:subdomains => ['en'])
        new_uri.to_s.should eq 'http://en.example.com'

        new_uri = uri.map(:subdomains => ['one', 'two'])
        new_uri.to_s.should eq 'http://one.two.example.com'
      end

      it "replaces existing additional subdomains" do
        uri = Uri.new('http://en.example.com')
        new_uri = uri.map(:subdomains => ['de'])
        new_uri.to_s.should eq 'http://de.example.com'
      end

      it "changes existing additional subdomains" do
        uri = Uri.new('http://en.example.com')
        new_uri = uri.map(:subdomains) { |ss| ss.map(&:upcase) }
        new_uri.to_s.should eq 'http://EN.example.com'
      end
    end

    describe "#map(:query)" do
      let(:uri) { Uri.new('http://example.com?search=foo') }

      it "adds new query parameters" do
        new_uri = uri.map(:query) { |q| q['color'] = 'red'; q }
        new_uri.to_s.should eq 'http://example.com?search=foo&color=red'
      end

      it "replaces query parameters" do
        new_uri = uri.map(:query) { |q| q['search'] = 'bar'; q }
        new_uri.to_s.should eq 'http://example.com?search=bar'
      end

      it "doesn't distinguish between strings and symbols" do
        with_symbol = uri.map(:query) { |q| q[:search] = 'bar'; q }
        with_string = uri.map(:query) { |q| q['search'] = 'bar'; q }

        with_symbol.to_s.should eq with_string.to_s
      end

      it "can modify the uri in-place or make a new copy" do
        new_uri = uri.map(:query) { |q| q['search'] = 'bar'; q }
        new_uri.to_s.should_not eq uri.to_s

        uri.map!(:query) { |q| q['search'] = 'bar'; q }
        new_uri.to_s.should eq uri.to_s
      end

      it "can use the shorthand form of a hash" do
        new_uri = uri.map(:query => {:color => 'blue'})
        new_uri.to_s.should eq 'http://example.com?color=blue'
      end
    end
  end
end
