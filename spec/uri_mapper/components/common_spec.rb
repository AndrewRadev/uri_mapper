require 'spec_helper'
require 'uri_mapper/components'

module UriMapper
  module Components
    describe Common do
      class TestComponent < Common
        def initialize(body)
          @body = body
        end

        def to_s
          @body
        end
      end

      describe ".build" do
        let(:component) { TestComponent.new('body') }

        it "returns its argument if it's already a component" do
          TestComponent.build(component).should equal component
        end

        it "instantiates a new component" do
          TestComponent.build('body').should_not equal component
          TestComponent.build('body').should eq component
        end
      end

      describe "#==" do
        it "uses to_s to compare components" do
          first  = TestComponent.new('body')
          second = TestComponent.new('body')

          def first.to_s;  'one'; end
          def second.to_s; 'two'; end

          first.should_not eq second

          def first.to_s;  'one'; end
          def second.to_s; 'one'; end

          first.should eq second
        end
      end
    end
  end
end
