class AddSoftDeleteToBlogs < ActiveRecord::Migration[6.1]
  def change
    add_column :blogs, :deleted_at, :datetime
  end
end
