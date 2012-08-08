PairGroup = Struct.new(:left_membership, :top_membership) do

  def team
    left_membership.team
  end

  def ids
    [left_membership.id, top_membership.id].join(",")
  end

end
