class CompaniesController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :show]

  before_filter :load_company, only: [:show, :edit, :update, :destroy]

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

  private

  def load_company
    @company = Company.find(params[:id])
  end
end
