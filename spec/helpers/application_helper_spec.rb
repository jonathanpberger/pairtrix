require 'spec_helper'

describe ApplicationHelper do
  describe "#yes_no" do
    subject { helper.yes_no(bool) }

    context "when 'true'" do
      let(:bool) { true }
      it { should == 'Yes' }
    end

    context "when 'false'" do
      let(:bool) { false }
      it { should == 'No' }
    end
  end
end
