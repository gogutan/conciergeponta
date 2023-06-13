class CreateMemos < ActiveRecord::Migration[7.0]
  def change
    create_table :memos do |t|
      t.integer :service_type, null: false, default: 0
      t.string :uid, null: false, default: ''
      t.string :body, null: false, default: '', index: { unique: true }

      t.timestamps
    end
  end
end
