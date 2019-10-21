class Task < ApplicationRecord
  belongs_to :todo
  has_many :sub_tasks
end
