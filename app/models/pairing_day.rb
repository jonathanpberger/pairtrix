class PairingDay < ActiveRecord::Base
  attr_accessible :team_id, :pairing_date

  belongs_to :team

  has_many :pairs, dependent: :destroy

  validates_presence_of :team_id, :pairing_date
  validates_uniqueness_of :pairing_date, scope: :team_id

  def to_param
    "#{id}-#{pairing_date.to_s(:db)}"
  end

end
