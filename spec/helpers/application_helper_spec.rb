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

  describe "#avatar_for" do
    subject { helper.avatar_for(employee) }

    let(:employee) { double(:employee, avatar?: has_avatar, avatar_url: avatar_url, name: "name") }

    context "with avatar" do
      let(:has_avatar) { true }
      let(:avatar_url) { "s3/avatar.png" }

      it "displays the uploaded avatar" do
        should =~ /s3/
      end
    end

    context "without avatar" do
      let(:has_avatar) { false }
      let(:avatar_url) { "" }

      it "displays the default" do
        should =~ /layout/
      end
    end
  end
end
