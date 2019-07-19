class AddIndexToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_index :accounts, :datetime
  end
end
