require 'spec_helper'

describe MembershipRequestsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:company) { FactoryGirl.create(:company, user: user) }
  let(:membership_request) { FactoryGirl.create(:membership_request, company: company) }

  def valid_session
    {}
  end

  def mock_user
    controller.stub(:current_user).and_return(user)
  end

  before do
    company.should be
  end

  describe "POST create" do
    before do
      mock_user
    end

    def do_post
      post :create, { company_id: company.to_param }, valid_session
    end

    describe "with valid params" do
      context "without an existing request" do
        let(:mailer) { double(:mailer, deliver: true) }

        before do
          MembershipRequestMailer.should_receive(:membership_request_email).and_return(mailer)
        end

        it "creates a new MembershipRequest" do
          expect {
            do_post
          }.to change(MembershipRequest, :count).by(1)
        end

        it "redirects to the created membership_request" do
          do_post
          response.should redirect_to(company_url(company))
        end
      end

      context "with an existing request" do
        let!(:existing_request) { FactoryGirl.create(:membership_request, company: company, user: user) }

        it "fails to create a new MembershipRequest" do
          expect {
            do_post
          }.to change(MembershipRequest, :count).by(0)
        end

        it "redirects to the created membership_request" do
          do_post
          response.should redirect_to(company_url(company))
        end
      end

    end
  end

  describe "PUT update" do
    let(:commit_type) { "Approve" }

    def do_update
      put :update, { id: membership_request.to_param, membership_request: {}, commit: commit_type}, valid_session
    end

    before do
      mock_user
      membership_request.should be
    end

    describe "with valid params" do
      context "when approved" do
        it "sets the membership_request to approved" do
          do_update
          assigns(:membership_request).status.should == "Approved"
        end

        it "creates a new CompanyMembership" do
          expect {
            do_update
          }.to change(CompanyMembership, :count).by(1)
          CompanyMembership.last.user_id.should == membership_request.user_id
        end
      end

      context "when denied" do
        let(:commit_type) { "Deny" }

        it "sets the membership_request to denied" do
          do_update
          assigns(:membership_request).status.should == "Denied"
        end

        it "fails to create a new CompanyMembership" do
          expect {
            do_update
          }.to change(CompanyMembership, :count).by(0)
        end
      end

      it "redirects to the user_dashboard" do
        do_update
        response.should redirect_to(company_url(company))
      end
    end
  end
end
