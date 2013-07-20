require 'spec_helper'
require 'uri_mapper/query'

module UriMapper
  describe Query do
    describe ".build" do
      let(:query) { Query.new('foo=bar') }

      it "returns its argument if it's already a Query" do
        Query.build(query).should equal query
      end

      it "instantiates a new Query" do
        Query.build(query.to_s).should_not equal query
        Query.build(query.to_s).should eq query
      end
    end
  end
end
