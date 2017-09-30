class CreateFoodstuffs < ActiveRecord::Migration[5.1]
  def change
    create_table :foodstuffs do |t|
      t.string :title

      t.timestamps
    end
  end
end
