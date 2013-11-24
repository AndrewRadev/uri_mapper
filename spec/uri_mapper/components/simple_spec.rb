require 'spec_helper'
require 'uri_mapper/components'

module UriMapper
  module Components
    describe Simple do
      it "acts as a simple wrapper" do
        Simple.build('a string').raw.should eq 'a string'
        Simple.build(['a', 'list']).raw.should eq ['a', 'list']
        Simple.build({'a' => 'hash'}).raw.should eq('a' => 'hash')
      end

      it "is overridden upon merging" do
        component = Simple.build('a string').merge(:one => 'two')
        component.raw.should eq(:one => 'two')
      end

      it "delegates #to_s to its raw contents" do
        Simple.build('something').to_s.should eq 'something'
        Simple.build(:something).to_s.should eq 'something'
      end
    end
  end
end
