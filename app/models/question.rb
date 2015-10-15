class Question < ActiveRecord::Base
  validates :poll_id, presence: true

  belongs_to(
    :poll,
    class_name: 'Poll',
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :answer_choices,
    class_name: 'AnswerChoice',
    foreign_key: :question_id,
    primary_key: :id
  )

  has_many(
    :responses,
    through: :answer_choices,
    source: :responses
  )

  def slow_results
    answers = answer_choices
    response_count = {}
    answers.each do |ac|
      response_count[ac.answer_text] = ac.responses.count
    end
    response_count
  end

  def faster_results
    answers = answer_choices.includes(:responses)
    response_count = {}
    answers.each do |ac|
      response_count[ac.answer_text] = ac.responses.length
    end
    response_count
  end

  def even_faster_results
    answers = AnswerChoice.find_by_sql([<<-SQL, self.id])
      SELECT
         answer_choices.*,
         COUNT(responses.answer_id) AS totals
      FROM
        answer_choices
      LEFT OUTER JOIN
        responses
        ON answer_choices.id = responses.answer_id
      WHERE
        question_id = ?
      GROUP BY
        answer_choices.id
    SQL

    output = {}
    answers.each do |answer|
      output[answer.answer_text] = answer.totals
    end

    output
  end

  def active_record_results
    answers = self
      .answer_choices
      .select('answer_choices.*, COUNT(responses.answer_id) AS totals')
      .joins('LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_id')
      .where('question_id = ?', self.id)
      .group('answer_choices.id')

    output = {}
    answers.each do |answer|
      output[answer.answer_text] = answer.totals
    end

    output
  end

end
