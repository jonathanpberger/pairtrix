class PairingDaysController < ApplicationController

  before_filter :load_team, only: [:index, :new, :create]
  before_filter :load_pairing_day, except: [:index, :new, :create]

  def index
    @pairing_days = @team.pairing_days
  end

  def show
  end

  def new
    @pairing_day = @team.pairing_days.build(pairing_date: Date.current)
  end

  def edit
  end

  def create
    @pairing_day = @team.pairing_days.build(params[:pairing_day])

    if @pairing_day.save
      redirect_to team_url(@pairing_day.team), flash: { success: 'Pairing Day was successfully created.' }
    else
      render action: "new"
    end
  end

  def update
    if @pairing_day.update_attributes(params[:pairing_day])
      redirect_to team_url(@pairing_day.team), flash: { success: 'Pairing Day was successfully updated.' }
    else
      render action: "edit"
    end
  end

  def destroy
    @pairing_day.destroy
    redirect_to team_url(@pairing_day.team)
  end

  private

  def load_pairing_day
    @pairing_day = PairingDay.find(params[:id])
  end

  def load_team
    @team = Team.find(params[:team_id])
  end
end
