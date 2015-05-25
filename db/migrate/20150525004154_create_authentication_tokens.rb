class CreateAuthenticationTokens < ActiveRecord::Migration
  def change
    create_table :authentication_tokens do |t|
      t.references :authenticatable, polymorphic: true
      t.string :token_digest
      t.string :salt
      t.timestamps null: false
    end
  end
end
