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

  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_up(user)
    visit new_user_registration_path
    fill_in 'Email',      with: user.email
    fill_in 'Password',   with: user.password
    fill_in 'Password confirmation',
      with: user.password_confirmation
    click_on 'Sign up'
  end
end
