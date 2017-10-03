class AddRecipeIdToMaterials < ActiveRecord::Migration[5.1]
  def change
    add_column :materials, :recipe_id, :integer
  end
end
