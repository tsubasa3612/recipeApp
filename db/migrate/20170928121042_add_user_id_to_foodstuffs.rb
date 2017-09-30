class AddUserIdToFoodstuffs < ActiveRecord::Migration[5.1]
  def change
    add_column :foodstuffs, :user_id, :integer
  end
end
