class Response < ActiveRecord::Base
  validates :user_id, :answer_id, presence: true
  validate :respondent_has_not_already_answered_question?
  validate :respondent_did_not_author_poll?

  belongs_to(
    :respondent,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  belongs_to(
    :answer_choice,
    class_name: 'AnswerChoice',
    foreign_key: :answer_id,
    primary_key: :id
  )

  has_one(
    :question,
    through: :answer_choice,
    source: :question
  )

  has_one(
    :poll,
    through: :question,
    source: :poll,
  )


  def respondent_has_not_already_answered_question?
    unless sibling_responses.where("user_id = ?", (self.user_id)).empty?
      errors[:respondent] << 'user cannot vote twice'
    end
  end

  def sibling_responses
    current_user_id = self.user_id
    current_id = self.id.nil? ? -1 : self.id
    current_question_id = self.question.id

    Response.joins(:answer_choice => :question)
      .where("responses.user_id = ?", current_user_id)
      .where("responses.id != ?", current_id)
      .where("questions.id = ?", current_question_id)
  end

  def respondent_did_not_author_poll?
    unless Response.joins(:question, :poll)
      .where('author_id = ? AND questions.id = ?', self.user_id, self.question.id)
      .empty?

      errors[:respondent] << "author cannot vote on their own poll"
    end
  end


end
