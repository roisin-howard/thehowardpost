class RemoveFirstLastFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :first, :string
    remove_column :users, :last, :string
  end
end
