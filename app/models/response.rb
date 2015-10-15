class Response < ActiveRecord::Base
  validates :user_id, :answer_id, presence: true
  validates :respondent_has_not_already_answered_question?
  validates :respondent_did_not_author_poll?

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
    sibling_responses.where("user_id = ?", (self.user_id)).empty?
  end

  def sibling_responses
    current_id = self.id.nil? ? -1 : self.id
    self.question.responses.where("responses.id != ?", current_id)

  end

  def respondent_did_not_author_poll?
    self.poll.author_id != self.user_id
  end


end
