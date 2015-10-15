class CreatePollQuestionAnswerChoiceResponse < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.integer :author_id

      t.timestamps
    end

    create_table :questions do |t|
      t.text :text
      t.integer :poll_id

      t.timestamps
    end

    create_table :answer_choices do |t|
      t.text :answer_text
      t.integer :question_id

      t.timestamps
    end

    create_table :responses do |t|
      t.integer :user_id
      t.integer :answer_id

      t.timestamps
    end
  end
end
