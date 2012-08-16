class PairMatrixCalculator

  def initialize(pairs, memberships)
    @pairs = pairs
    @memberships = memberships
  end

  def complete_pair_hash
    @memberships.inject({}) do |pair_hash, membership|
      pair_hash[membership.employee_id] = hash_for_membership(membership)
      pair_hash
    end
  end

  private

  def selected_pairs(membership)
    @pairs.select { |pair| pair.has_membership?(membership) }
  end

  def hash_for_membership(membership)
    selected_pairs(membership).inject({}) do |hash, selected_pair|
      other_membership_id = selected_pair.other_membership(membership).employee_id
      if hash.has_key?(other_membership_id)
        hash[other_membership_id] += 1
      else
        hash[other_membership_id] = 1
      end
      hash
    end
  end
end
