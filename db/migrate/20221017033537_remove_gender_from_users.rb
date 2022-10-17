class RemoveGenderFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :gender, :integer
  end
end
