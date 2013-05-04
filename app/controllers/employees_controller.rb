class EmployeesController < ApplicationController
  respond_to :html, :json

  load_and_authorize_resource :company
  load_and_authorize_resource :employee, through: :company, shallow: true
  permit_params :first_name, :last_name, :company_id, :do_not_pair,
                :avatar, :remote_avatar_url, :avatar_cache, :remove_avatar
  def index
    @employees = @company.employees.ordered_by_last_name
  end

  def show
  end

  def new
    @employee = @company.employees.build
  end

  def edit
    respond_with @employee
  end

  def create
    @employee = @company.employees.new(employee_params)
    @employee.save
    respond_with @employee, location: company_employees_url(@company)
  end

  def update
    if @employee.update_attributes(employee_params)
      respond_with @employee do |format|
        format.json { render json: @employee.to_json, status: :accepted }
        format.html { respond_with @employee, location: company_employees_url(@employee.company) }
      end
    else
      respond_with @employee
    end
  end

  def destroy
    @employee.destroy
    respond_with @employee, location: company_employees_url(@employee.company)
  end

  private

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :company_id,
                                     :do_not_pair, :avatar, :remote_avatar_url,
                                     :avatar_cache, :remove_avatar)
  end

end
