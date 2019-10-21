class Task < ApplicationRecord
  acts_as_paranoid
  belongs_to :todo
  has_many :sub_tasks
end
