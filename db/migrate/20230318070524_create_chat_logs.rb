class CreateChatLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_logs do |t|
      t.string :line_user_id, null: false, default: ''
      t.integer :role, null: false, default: 0
      t.string :content, null: false, default: ''
      t.integer :prompt_tokens, null: false, default: 0
      t.integer :completion_tokens, null: false, default: 0
      t.timestamps
    end
  end
end
