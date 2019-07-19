class AddActiveAndUserIdToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :active, :boolean, default: true
    add_column :accounts, :user_id, :integer
  end
end
