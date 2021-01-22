class Blog < ApplicationRecord

  include Visible
  
  belongs_to :user, class_name: "User", foreign_key: :users_id, required: false
  has_many :comments,  dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  scope :not_deleted, -> { where(:deleted_at => nil)}   # Scope for the active posts.

  def self.search(search)
    where("title || body ILIKE ?", "%#{search}%")
  end

  def soft_delete
    update(deleted_at: DateTime.current)  # soft delete the blog
  end

  def undo_delete
    update(deleted_at: nil)  # undo the soft delete
  end

  def archive
    puts "in archive at blog model"
    update(status: 'archived')
  end
end
