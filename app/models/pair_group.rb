class PairGroup
  attr_reader :left_membership, :top_membership

  def initialize(left_membership, top_membership)
    @left_membership = left_membership
    @top_membership = top_membership
  end

  def team
    @left_membership.team
  end

  def ids
    [@left_membership.id, @top_membership.id].join(",")
  end

  def current_pair?
    if (pairing_day = PairingDay.where(pairing_date: Date.current).first)
      pairing_day.pairs.detect do |pair|
        pair.has_membership?(@left_membership) && pair.has_membership?(@top_membership)
      end
    end
  end

end
