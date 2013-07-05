require 'spec_helper'
require 'request_mapper/uri'

module RequestMapper
  describe Uri do
    describe "#map(:query)" do
      let(:uri) { Uri.new('http://example.com?search=foo') }

      it "adds new query parameters" do
        new_uri = uri.map(:query) { |q| q['color'] = 'red' }
        new_uri.to_s.should eq 'http://example.com?search=foo&color=red'
      end

      it "replaces query parameters" do
        new_uri = uri.map(:query) { |q| q['search'] = 'bar' }
        new_uri.to_s.should eq 'http://example.com?search=bar'
      end

      it "doesn't distinguish between strings and symbols" do
        with_symbol = uri.map(:query) { |q| q[:search] = 'bar' }
        with_string = uri.map(:query) { |q| q['search'] = 'bar' }

        with_symbol.to_s.should eq with_string.to_s
      end

      it "can modify the uri in-place or make a new copy" do
        new_uri = uri.map(:query) { |q| q['search'] = 'bar' }
        new_uri.to_s.should_not eq uri.to_s

        uri.map!(:query) { |q| q['search'] = 'bar' }
        new_uri.to_s.should eq uri.to_s
      end
    end
  end
end
