class Blog < ApplicationRecord

  belongs_to :user, class_name: "User", foreign_key: :users_id, required: false
  has_many :comments,  dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  def self.search(search)
    where("title || body ILIKE ?", "%#{search}%")
  end
end
