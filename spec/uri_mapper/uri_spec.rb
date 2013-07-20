require 'spec_helper'
require 'uri_mapper/uri'

module UriMapper
  describe Uri do
    describe "#map" do
      let(:uri) { Uri.new('http://example.com?search=foo') }

      it "allows modification of the entire uri" do
        new_uri = uri.map { |u| u.query['search'] = 'bar' }
        new_uri.to_s.should eq 'http://example.com?search=bar'
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
