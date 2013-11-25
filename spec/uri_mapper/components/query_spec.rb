require 'spec_helper'
require 'ostruct'
require 'uri_mapper/components'

module UriMapper
  module Components
    describe Query do
      describe "#merge" do
        it "combines two queries" do
          first  = Query.new('one=blue')
          second = Query.new('two=red')

          first.merge(second).to_s.should eq 'one=blue&two=red'
        end

        it "overrides the first query's params" do
          first  = Query.new('one=blue&two=red')
          second = Query.new('one=green')

          first.merge(second).to_s.should eq 'one=green&two=red'
        end

        it "combines a query and something coercable to a query" do
          query = Query.new('one=blue')

          query.merge('two' => 'red').to_s.should eq 'one=blue&two=red'
          query.merge('two=red').to_s.should eq 'one=blue&two=red'
          query.merge('one=red').to_s.should eq 'one=red'
        end
      end

      describe "#to_s" do
        it "leaves the given string untouched if no operations on it have been made" do
          string = 'foo=bar'
          query = Query.new(string)
          query.to_s.should equal string

          query['foo'] = 'bar'
          query.to_s.should_not equal string
          query.to_s.should eq 'foo=bar'
        end

        it "builds a query from simple key=value pairs" do
          query = Query.new(:one => 'two', :three => 4)
          query.to_s.should eq 'one=two&three=4'
        end

        it "builds a query from key={hash} pairs" do
          query = Query.new(:one => {:two => 'three'})
          CGI.unescape(query.to_s).should eq 'one[two]=three'

          query = Query.new(:one => {:two => {'three' => 'four'}})
          CGI.unescape(query.to_s).should eq 'one[two][three]=four'
        end

        it "builds a query from key=[list] pairs" do
          query = Query.new(:one => ['two', 'three'])
          CGI.unescape(query.to_s).should eq 'one[]=two&one[]=three'

          query = Query.new(:one => [['two', 'three'], 'four'])
          CGI.unescape(query.to_s).should eq 'one[][]=two&one[][]=three&one[]=four'
        end

        it "uses to_query if the object responds to it" do
          query = Query.new(OpenStruct.new(:to_query => 'QUERY'))
          query.to_s.should eq 'QUERY'

          query = Query.new(:search => OpenStruct.new(:to_query => 'QUERY'))
          query.to_s.should eq 'search=QUERY'
        end
      end
    end
  end
end
