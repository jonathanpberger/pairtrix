class CompanyMembershipsController < ApplicationController

  load_and_authorize_resource :company
  load_and_authorize_resource :company_membership, through: :company, shallow: true

  def index
    @company_memberships = @company.company_memberships.all
  end

  def show
  end

  def new
    @company_membership = @company.company_memberships.build
  end

  def edit
  end

  def create
    @company_membership = @company.company_memberships.new(params[:company_membership])

    if @company_membership.save
      if !(membership_request = @company.membership_requests.where(user_id: @company_membership.user_id).first)
        @company.membership_requests.create(user_id: @company_membership.user_id, status: "Approved")
      end

      redirect_to company_company_memberships_url(@company_membership.company), flash: { success: 'Company Membership was successfully created.' }
    else
      render action: "new"
    end
  end

  def update
    if @company_membership.update_attributes(params[:company_membership])
      redirect_to company_company_memberships_url(@company_membership.company), flash: { success: 'Company Membership was successfully updated.' }
    else
      render action: "edit"
    end
  end

  def destroy
    @company_membership.destroy
    redirect_to company_company_memberships_url(@company_membership.company)
  end
end
