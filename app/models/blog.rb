class Blog < ApplicationRecord
  belongs_to :user
  validates :email, presence: true
  validates :title, presence: true, allow_nil: false
end
