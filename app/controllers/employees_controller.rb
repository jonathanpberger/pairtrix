class EmployeesController < ApplicationController

  before_filter :load_company, only: [:index, :new, :create]
  before_filter :load_employee, only: [:show, :edit, :update, :destroy]

  def index
    @employees = @company.employees.ordered_by_last_name
  end

  def show
  end

  def new
    @employee = @company.employees.build
  end

  def edit
  end

  def create
    @employee = @company.employees.new(params[:employee])

    if @employee.save
      redirect_to company_employees_url(@employee.company), flash: { success: 'Employee was successfully created.' }
    else
      render action: "new"
    end
  end

  def update
    if @employee.update_attributes(params[:employee])
      redirect_to company_employees_url(@employee.company), flash: { success: 'Employee was successfully updated.' }
    else
      render action: "edit"
    end
  end

  def destroy
    @employee.destroy
    redirect_to company_employees_url(@employee.company)
  end

  private

  def load_company
    @company = Company.find(params[:company_id])
  end

  def load_employee
    @employee = Employee.find(params[:id])
  end
end
