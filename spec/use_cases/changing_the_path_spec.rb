require 'spec_helper'
require 'uri_mapper'

module UriMapper
  describe "Changing the path" do
    specify "replacing" do
      uri = Uri.new('http://example.com/one/two?search=something')

      cases = [
        uri.map(:path => %w[three four five]),
        uri.map(:path => 'three/four/five'),
        uri.map(:path => '/three/four/five'),
        uri.map(:path) { |_| '/three/four/five' },
        uri.map(:path) { |_| Path.build('/three/four/five') },
      ]

      cases.each do |new_uri|
        new_uri.to_s.should eq 'http://example.com/three/four/five?search=something'
      end
    end

    specify "adding" do
      uri = Uri.new('http://example.com/one/two?search=something')

      cases = [
        uri.map(:path) { |p| p[2] = 'three'; p[3] = 'four'; p },
        uri.map(:path) { |p| p + %w(three four) },
        uri.map(:path) { |p| p + '/three/four' },
        uri.map(:path) { |p| p.merge!('/three/four') },
        uri.map(:path) { |p| p += '/three/four' },
        uri.map(:path) { |p| p + '/three/four' },
        uri.merge(:path => '/three/four'),
        uri.merge(:path => %w(three four)),
      ]

      cases.each do |new_uri|
        new_uri.to_s.should eq 'http://example.com/one/two/three/four?search=something'
      end
    end

    specify "removing" do
      uri = Uri.new('http://example.com/one/two?search=something')

      cases = [
        uri.map(:path) { |p| nil },
        uri.map(:path) { |p| [] },
        uri.map(:path) { |p| '' },
        uri.map(:path => nil),
      ]

      cases.each do |new_uri|
        new_uri.path.to_a.should eq []
        new_uri.to_s.should eq 'http://example.com?search=something'
      end
    end
  end
end
