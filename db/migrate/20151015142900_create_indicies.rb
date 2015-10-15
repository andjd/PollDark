class CreateIndicies < ActiveRecord::Migration
  def change
    add_index :answer_choices, :question_id
    add_index :polls, :author_id
    add_index :questions, :poll_id
    add_index :responses, :answer_id
    add_index :responses, :user_id
  end
end
