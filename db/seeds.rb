# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ActiveRecord::Base.transaction do
  names = %w(able beth carrie donald edward)
  users = names.map { |name| User.create!(user_name: name) }

  polls_arr = ['poll1', 'poll2']
  polls = []
  polls_arr.length.times do |i|
    polls << Poll.create!(title: polls_arr[i], author_id: users[i].id)
  end

  polls.each do |poll|
    2.times do |i|
      poll.questions.create!(text: "Question#{i}")
    end
  end
  Question.all.each do |question|
    3.times do |i|
      question.answer_choices.create!(answer_text: 'Choose Me! ' * (i + 1))
    end
  end

  AnswerChoice.all.each do |ac|
    ac.responses.create!(user_id: rand(4))
  end

end
