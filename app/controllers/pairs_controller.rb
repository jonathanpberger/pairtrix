class PairsController < ApplicationController

  before_filter :load_pairing_day, only: [:index, :new, :create]
  before_filter :load_pair, except: [:index, :new, :create]

  def index
    @pairs = @pairing_day.pairs
  end

  def show
  end

  def new
    @pair = @pairing_day.pairs.build
  end

  def edit
  end

  def create
    @pair = @pairing_day.pairs.build(params[:pair])

    if @pair.save

      @pair.pair_memberships.each do |pair_membership|
        pair_membership.save!
      end

      respond_to do |format|
        format.html do
          redirect_url = @pairing_day.available_team_memberships? ? new_pairing_day_pair_url(@pairing_day) : pairing_day_url(@pairing_day)
          redirect_to redirect_url, flash: { success: 'Pair was successfully created.' }
        end

        format.json do
          render(json: { success: true, pairId: @pair.id })
        end
      end
    else
      render action: "new"
    end
  end

  def update
    if @pair.update_attributes(params[:pair])
      redirect_to pairing_day_url(@pair.pairing_day), flash: { success: 'Pair was successfully updated.' }
    else
      render action: "edit"
    end
  end

  def destroy
    @pair.destroy
    respond_to do |format|
      format.html { redirect_to pairing_day_url(@pair.pairing_day) }
      format.json { render json: { success: true } }
    end
  end

  private

  def load_pair
    @pair = Pair.find(params[:id])
  end

  def load_pairing_day
    if params[:pairing_day_id]
      @pairing_day = PairingDay.find(params[:pairing_day_id])
    elsif params[:team_id]
      team = Team.find(params[:team_id])
      if (!@pairing_day = team.pairing_days.where(pairing_date: Date.current).first)
        @pairing_day = team.pairing_days.create(pairing_date: Date.current)
      end
    end
  end
end
