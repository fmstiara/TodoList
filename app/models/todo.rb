class Todo < ApplicationRecord
  acts_as_paranoid
  has_many :tasks, -> { with_deleted }
  accepts_nested_attributes_for :tasks, allow_destroy: true
end
