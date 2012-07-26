require 'spec_helper'

describe EmployeesController do

  def valid_attributes
    FactoryGirl.attributes_for(:employee)
  end

  def valid_session
    {}
  end

  def mock_admin
    user = mock(:user, admin?: true)
    controller.stub(:current_user).and_return(user)
  end

  describe "GET index" do
    it "assigns all employees as @employees" do
      employee = FactoryGirl.create(:employee)
      get :index, {}, valid_session
      assigns(:employees).should eq([employee])
    end
  end

  describe "GET show" do
    it "assigns the requested employee as @employee" do
      employee = FactoryGirl.create(:employee)
      get :show, {:id => employee.to_param}, valid_session
      assigns(:employee).should eq(employee)
    end
  end

  describe "GET new" do
    it "assigns a new employee as @employee" do
      mock_admin
      get :new, {}, valid_session
      assigns(:employee).should be_a_new(Employee)
    end
  end

  describe "GET edit" do
    it "assigns the requested employee as @employee" do
      mock_admin
      employee = FactoryGirl.create(:employee)
      get :edit, {:id => employee.to_param}, valid_session
      assigns(:employee).should eq(employee)
    end
  end

  describe "POST create" do
    before do
      mock_admin
    end

    describe "with valid params" do
      it "creates a new Employee" do
        expect {
          post :create, {:employee => valid_attributes}, valid_session
        }.to change(Employee, :count).by(1)
      end

      it "assigns a newly created employee as @employee" do
        post :create, {:employee => valid_attributes}, valid_session
        assigns(:employee).should be_a(Employee)
        assigns(:employee).should be_persisted
      end

      it "redirects to the created employee" do
        post :create, {:employee => valid_attributes}, valid_session
        response.should redirect_to(employees_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved employee as @employee" do
        # Trigger the behavior that occurs when invalid params are submitted
        Employee.any_instance.stub(:save).and_return(false)
        post :create, {:employee => {}}, valid_session
        assigns(:employee).should be_a_new(Employee)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Employee.any_instance.stub(:save).and_return(false)
        post :create, {:employee => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before do
      mock_admin
    end

    describe "with valid params" do
      it "updates the requested employee" do
        employee = FactoryGirl.create(:employee)
        Employee.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => employee.to_param, :employee => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested employee as @employee" do
        employee = FactoryGirl.create(:employee)
        put :update, {:id => employee.to_param, :employee => valid_attributes}, valid_session
        assigns(:employee).should eq(employee)
      end

      it "redirects to the employee" do
        employee = FactoryGirl.create(:employee)
        put :update, {:id => employee.to_param, :employee => valid_attributes}, valid_session
        response.should redirect_to(employees_url)
      end
    end

    describe "with invalid params" do
      it "assigns the employee as @employee" do
        employee = FactoryGirl.create(:employee)
        # Trigger the behavior that occurs when invalid params are submitted
        Employee.any_instance.stub(:save).and_return(false)
        put :update, {:id => employee.to_param, :employee => {}}, valid_session
        assigns(:employee).should eq(employee)
      end

      it "re-renders the 'edit' template" do
        employee = FactoryGirl.create(:employee)
        # Trigger the behavior that occurs when invalid params are submitted
        Employee.any_instance.stub(:save).and_return(false)
        put :update, {:id => employee.to_param, :employee => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      mock_admin
    end

    it "destroys the requested employee" do
      employee = FactoryGirl.create(:employee)
      expect {
        delete :destroy, {:id => employee.to_param}, valid_session
      }.to change(Employee, :count).by(-1)
    end

    it "redirects to the employees list" do
      employee = FactoryGirl.create(:employee)
      delete :destroy, {:id => employee.to_param}, valid_session
      response.should redirect_to(employees_url)
    end
  end

end
