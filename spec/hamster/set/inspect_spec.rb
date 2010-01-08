require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/set'

describe Hamster::List do

  describe "#inspect" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.inspect
      end

    end

    [
      [[], "{}"],
      [["A"], "{\"A\"}"],
      [[1, 2, 3], "{1, 2, 3}"]
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          original = Hamster.set(*values)
          @result = original.inspect
        end

        it "returns #{expected.inspect}" do
          @result.should == expected
        end

      end

    end

  end

end