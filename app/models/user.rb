class User < ActiveRecord::Base
  validates :user_name, :uniqueness => true

  has_many(
    :polls,
    class_name: 'Poll',
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many(
    :responses,
    class_name: 'Response',
    foreign_key: :user_id,
    primary_key: :id
  )

  def completed_polls
    var = Poll.find_by_sql([<<-SQL, self.id])
      SELECT
        polls.*
      FROM polls
      JOIN questions ON questions.poll_id = polls.id
      JOIN answer_choices ON question_id = questions.id
      LEFT OUTER JOIN (SELECT *
        FROM responses
        WHERE responses.user_id = ?
      ) AS user_responses ON user_responses.answer_id = answer_choices.id
      GROUP BY polls.id
      HAVING COUNT(questions.id) = COUNT(user_responses.id)

    SQL
  end



end
