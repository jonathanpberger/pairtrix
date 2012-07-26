class Employee < ActiveRecord::Base
  attr_accessible :first_name, :last_name

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name, scope: :last_name

  class << self
    def ordered_by_last_name
      order("last_name ASC, first_name ASC")
    end
  end

  def name
    [last_name, first_name].join(", ")
  end

end
