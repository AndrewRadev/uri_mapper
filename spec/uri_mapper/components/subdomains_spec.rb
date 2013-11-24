require 'uri_mapper/components'

module UriMapper
  module Components
    describe Subdomains do
      it "parses subdomains from a given host" do
        subdomains = Subdomains.new('example.com')
        subdomains.to_a.should eq []

        subdomains = Subdomains.new('en.example.com')
        subdomains.to_a.should eq ['en']

        subdomains = Subdomains.new('one.two.example.com')
        subdomains.to_a.should eq ['one', 'two']
      end

      it "behaves like an enumerable" do
        subdomains = Subdomains.new('one.two.example.com')

        subdomains.map(&:upcase).should eq ['ONE', 'TWO']
      end
    end
  end
end
