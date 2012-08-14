class MembershipRequestsController < ApplicationController

  before_filter :authenticate_user!, only: :create

  load_and_authorize_resource :company
  load_and_authorize_resource :membership_request, through: :company, shallow: true

  def create
    if !(membership_request = @company.membership_requests.where(user_id: current_user.id).first)
      membership_request = @company.membership_requests.create(user_id: current_user.id, status: "Pending")
      MembershipRequestMailer.membership_request_email(membership_request).deliver
    end

    redirect_to company_url(@company), flash: { warning: 'Membership Request creation succeeded.' }
  end

  def update
    case params[:commit]
    when "Deny"
      params[:membership_request][:status] = "Denied"
    when "Approve"
      params[:membership_request][:status] = "Approved"
      @membership_request.company.company_memberships.create(user_id: @membership_request.user_id, role: "member")
    end

    @membership_request.update_attributes(params[:membership_request])
    redirect_to company_url(@membership_request.company), flash: { warning: 'Membership Request updated.' }
  end
end
