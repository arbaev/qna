class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.text :body, null: false
      t.boolean :correct, null: false, default: false
      t.references :question, foreign_key: true, null: false

      t.timestamps
    end
  end
end
