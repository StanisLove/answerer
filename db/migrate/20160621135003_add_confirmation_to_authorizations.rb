class AddConfirmationToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :confirmation_token, :string
    add_column :authorizations, :confirmed_at, :datetime
    add_column :authorizations, :confirmation_sent_at, :datetime
    add_index :authorizations, :confirmation_token
  end
end
