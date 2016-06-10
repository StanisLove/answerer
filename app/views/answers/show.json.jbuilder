json.(@answer, :id, :body, :user_id, :question_id)
json.url      question_answer_path(@answer.question, @answer)
json.edit_url edit_question_answer_path(@answer.question, @answer)
json.question_user_id @answer.question.user_id
json.voting_result    @answer.voting_result

if @answer.attachments.any?
  json.attachments @answer.attachments do |attachment|
    json.file_name  attachment.file.identifier
    json.url        attachment.file.url
    json.id         attachment.id

    json.destroy_link link_to 'Удалить', 
      question_answer_path(@answer.question, @answer, 
      answer: { attachments_attributes: { id: attachment.id, "_destroy" => true, } }), 
      remote: true, method: :patch
  end
else
  json.attachments { json.nil! }
end

if @answer.votes.pluck(:user_id).include? current_user.id
  json.vote_up_link   link_to "+", 
    vote_up_question_answer_path(@question, @answer),
    class: 'vote-link up', style: 'display:none;', 
    data: { answer_id: @answer.id }, remote: true, method: :patch

  json.vote_down_link link_to "&ndash;".html_safe,
    vote_down_question_answer_path(@question, @answer),
    class: 'vote-link down', style: 'display:none;', 
    data: { answer_id: @answer.id }, remote: true, method: :patch

  json.vote_reset_link link_to "Отменить",
    vote_reset_question_answer_path(@question, @answer),
    class: 'reset-vote-link', remote: true, method: :patch, 
    data: { answer_id: @answer.id } 
else
  json.vote_up_link   link_to "+", 
    vote_up_question_answer_path(@question, @answer),
    class: 'vote-link up',
    data: { answer_id: @answer.id }, remote: true, method: :patch

  json.vote_down_link link_to "&ndash;".html_safe,
    vote_down_question_answer_path(@question, @answer),
    class: 'vote-link down',
    data: { answer_id: @answer.id }, remote: true, method: :patch

  json.vote_reset_link link_to "Отменить",
    vote_reset_question_answer_path(@question, @answer),
    class: 'reset-vote-link', remote: true, method: :patch, 
    data: { answer_id: @answer.id }, style: 'display:none'
end

json.form render 'answers/form.html.haml', answer: @answer
