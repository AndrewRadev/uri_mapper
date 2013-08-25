require 'spec_helper'
require 'uri_mapper'

module UriMapper
  describe "Changing the query" do
    specify "replacing the query" do
      uri = Uri.new('http://example.com?search=something&color=blue')

      cases = [
        uri.map(:query => {:something => 'blue'}),
        uri.map(:query => 'something=blue'),
        uri.map(:query) { |q| {:something => 'blue'} },
        uri.map(:query) { |q| 'something=blue' },
        uri.map(:query) { |q| Query.build(:something => 'blue') },
      ]

      cases.each do |new_uri|
        new_uri.to_s.should eq 'http://example.com?something=blue'
      end
    end

    specify "adding to the query" do
      uri = Uri.new('http://example.com?search=something&color=blue')

      cases = [
        uri.map(:query) { |q| q[:color] = 'red'; q },
        uri.map(:query) { |q| q.merge!(:color => 'red') },
        uri.map(:query) { |q| q.merge!('color' => 'red') },
        uri.map(:query) { |q| q.merge!('color=red') },
        uri.map(:query) { |q| q += 'color=red' },
        uri.map(:query) { |q| q + 'color=red' },
      ]

      cases.each do |new_uri|
        new_uri.to_s.should eq 'http://example.com?search=something&color=red'
      end
    end
  end
end