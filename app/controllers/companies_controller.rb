class CompaniesController < ApplicationController

  load_and_authorize_resource

  def index
    @companies = Company.all
  end

  def show
  end

  def new
    @company = current_user.companies.build
  end

  def edit
  end

  def create
    @company = current_user.companies.build(params[:company])

    if @company.save
      @company.membership_requests.create(user_id: current_user.id, status: "Approved")
      @company.company_memberships.create(user_id: current_user.id, role: "admin")

      redirect_to companies_url, flash: { success: 'Company was successfully created.' }
    else
      render action: "new"
    end
  end

  def update
    if @company.update_attributes(params[:company])
      redirect_to companies_url, flash: { success: 'Company was successfully updated.' }
    else
      render action: "edit"
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_url
  end
end
