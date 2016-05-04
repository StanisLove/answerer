module AcceptanceHelper
  def create_question(question)
    visit new_question_path
    fill_in 'Заголовок',  with: question.title
    fill_in 'Вопрос',     with: question.body
    click_on 'Спросить'
  end

  def create_answer(question, answer)
    visit new_question_answer_path(question)
    fill_in 'Ответ',  with: answer.body
    click_on 'Отправить ответ'
  end
end
