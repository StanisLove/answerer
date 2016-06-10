ready = ->
  questionId = $('.question').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/comment', (data, channel) ->
    comment = $.parseJSON(data['comment']);
    type = comment.commentable_type
    id = comment.commentable_id
    $('textarea#comment_body').val('');
    $('.comment-errors').empty();
    $('#' + type + '-' + id + ' .comments').append(JST["comment"]({comment: comment}));
  
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
