require 'spec_helper'
require 'uri_mapper/simple_component'

module UriMapper
  describe SimpleComponent do
    it "acts as a simple wrapper" do
      SimpleComponent.build('a string').raw.should eq 'a string'
      SimpleComponent.build(['a', 'list']).raw.should eq ['a', 'list']
      SimpleComponent.build({'a' => 'hash'}).raw.should eq('a' => 'hash')
    end

    it "is overridden upon merging" do
      component = SimpleComponent.build('a string').merge(:one => 'two')
      component.raw.should eq(:one => 'two')
    end

    it "delegates #to_s to its raw contents" do
      SimpleComponent.build('something').to_s.should eq 'something'
      SimpleComponent.build(:something).to_s.should eq 'something'
    end
  end
end
