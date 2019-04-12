tim = User.create!(email: 'tim@qna.io', password: '123456')
zeus = User.create!(email: 'zeus@qna.io', password: '123456')
afina = User.create!(email: 'afina@qna.io', password: '123456')

authors = [tim, zeus, afina]

QUESTIONS_NUMBER = 6
ANSWERS_NUMBER = 3

QUESTIONS_NUMBER.times do |i|
  quest = Question.create!(title: "#{Faker::Coffee.blend_name} question",
                           body: "Coffe from #{Faker::Coffee.origin}. What does it taste like?",
                           author: authors.sample)
  ANSWERS_NUMBER.times do |j|
    Answer.create!(body: "It's a #{Faker::Coffee.notes} taste!",
                   question: quest,
                   author: authors.sample)
  end
end
