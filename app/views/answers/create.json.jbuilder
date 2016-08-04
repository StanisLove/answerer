json.call(@answer, :id, :body, :user_id, :question_id, :is_best)
json.url              answer_path(@answer)
json.edit_url         edit_answer_path(@answer)
json.best_url         choose_best_answer_path(@answer)
json.question_user_id @answer.question.user_id
json.voting_result    @answer.voting_result

if @answer.attachments.any?
  json.attachments @answer.attachments do |attachment|
    json.file_name  attachment.file.identifier
    json.url        attachment.file.url
    json.id         attachment.id
    json.destroy_link link_to 'Delete Answer',
                              answer_path(@answer,
                                          answer: { attachments_attributes: { id: attachment.id, '_destroy' => true } }),
                              remote: true, method: :patch if current_user.id == @answer.user_id
  end
else
  json.attachments { json.null! }
end

if @answer.votes.pluck(:user_id).include? current_user.id
  json.vote_up_link   link_to '+',
                              vote_up_answer_path(@answer),
                              class: 'vote-link up',            style: 'display:none;',
                              data:  { answer_id: @answer.id }, remote: true, method: :patch

  json.vote_down_link link_to '&ndash;'.html_safe,
                              vote_down_answer_path(@answer),
                              class: 'vote-link down',          style: 'display:none;',
                              data:  { answer_id: @answer.id }, remote: true, method: :patch

  json.vote_reset_link link_to 'Отменить',
                               vote_reset_answer_path(@answer),
                               class: 'reset-vote-link', remote: true, method: :patch,
                               data:  { answer_id: @answer.id }
else
  json.vote_up_link   link_to '+',
                              vote_up_answer_path(@answer),
                              class: 'vote-link up',
                              data:  { answer_id: @answer.id }, remote: true, method: :patch

  json.vote_down_link link_to '&ndash;'.html_safe,
                              vote_down_answer_path(@answer),
                              class: 'vote-link down',
                              data:  { answer_id: @answer.id }, remote: true, method: :patch

  json.vote_reset_link link_to 'Отменить',
                               vote_reset_answer_path(@answer),
                               class: 'reset-vote-link',         remote: true, method: :patch,
                               data:  { answer_id: @answer.id }, style: 'display:none'
end

json.form render 'answers/form', object: @answer,
                                 edit_answer_id: { id: "edit-answer-#{@answer.id}" },
                                 answer: @answer,
                                 id: { answer_id: @answer.id } if can? :update, @answer

json.comments render 'comments/comments', commentable: @answer

json.comment_form render 'comments/form', id: { answer_id: @answer.id },
                                          object: [@answer, @answer.comments.build],
                                          submit_class: 'add-comment-button' if can? :create, Comment
