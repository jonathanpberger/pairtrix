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

      redirect_url = @pair.available_team_memberships.any? ? new_pairing_day_pair_url(@pair.pairing_day) : pairing_day_url(@pair.pairing_day)
      redirect_to redirect_url, flash: { success: 'Pair was successfully created.' }
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
    redirect_to pairing_day_url(@pair.pairing_day)
  end

  private

  def load_pair
    @pair = Pair.find(params[:id])
  end

  def load_pairing_day
    @pairing_day = PairingDay.find(params[:pairing_day_id])
  end
end
