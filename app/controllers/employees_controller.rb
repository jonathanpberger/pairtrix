class EmployeesController < ApplicationController

  before_filter :load_employee, only: [:show, :edit, :update, :destroy]

  def index
    @employees = Employee.ordered_by_last_name
  end

  def show
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(params[:employee])

    if @employee.save
      redirect_to employees_url, flash: { success: 'Employee was successfully created.' }
    else
      render action: "new"
    end
  end

  def update
    if @employee.update_attributes(params[:employee])
      redirect_to employees_url, flash: { success: 'Employee was successfully updated.' }
    else
      render action: "edit"
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_url
  end

  private

  def load_employee
    @employee = Employee.find(params[:id])
  end
end
