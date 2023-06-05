class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :vote, null: false
      t.belongs_to :user, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
