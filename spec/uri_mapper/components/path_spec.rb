require 'spec_helper'
require 'uri_mapper/components'

module UriMapper
  module Components
    describe Path do
      describe "#merge" do
        it "combines two paths" do
          first  = Path.new('/foo/bar')
          second = Path.new('/baz/qux')

          first.merge(second).to_s.should eq '/foo/bar/baz/qux'
          (first + second).to_s.should eq '/foo/bar/baz/qux'
        end

        it "combines a path and something coercable to a path" do
          path = Path.new('/foo/bar')

          path.merge(['baz', 'qux']).to_s.should eq '/foo/bar/baz/qux'
        end
      end

      describe "#to_s" do
        it "leaves the given string untouched if it was valid and no operations on it have been made" do
          string = '/foo/bar'
          path = Path.new(string)
          path.to_s.should equal string

          string = 'foo/bar'
          path = Path.new(string)
          path.to_s.should eq '/foo/bar'

          string = '/foo/bar'
          path = Path.new(string)
          path[0] = 'changed'
          path.to_s.should eq '/changed/bar'
        end

        it "adds a leading / if necessary" do
          Path.new('foo/bar').to_s.should eq '/foo/bar'
          Path.new('foo/bar').to_a.should eq ['foo', 'bar']

          Path.new('/foo/bar').to_s.should eq '/foo/bar'
          Path.new('/foo/bar').to_a.should eq ['foo', 'bar']
        end

        it "builds a path from a list" do
          path = Path.new(['foo', 'bar'])
          path.to_s.should eq '/foo/bar'
        end
      end

      describe "#to_a" do
        it "generates a list of path elements" do
          path = Path.new('/one/two/three')
          path.to_a.should eq ['one', 'two', 'three']

          path = Path.new('one/two/three')
          path.to_a.should eq ['one', 'two', 'three']
        end
      end
    end
  end
end
