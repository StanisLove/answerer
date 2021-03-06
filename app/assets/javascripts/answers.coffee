# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show();

  $('.edit_answer input[type="submit"]').click ->
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).hide();
    $('#answer-' + answer_id + ' > .edit-answer-link').show();

  $('.best-answer-link').click (e) ->
    e.preventDefault();
    $('.best-answer-link').show();
    $('.answers > div > h3').html("Answer");
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('#answer-' + answer_id + ' > h3').html("The Best Answer");

  $('.answers .add-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('#answer-' + answer_id + ' .new_comment textarea').val('');
    $('#answer-' + answer_id + ' .new_comment').show();
    $('#answer-' + answer_id + ' .new_comment .edit_answer').show();

  $('.answers .add-comment-button').click ->
    answer_id = $(this).data('answerId')
    $('#answer-' + answer_id + ' .new_comment').hide();
    $('#answer-' + answer_id + ' .add-comment-link').show();

  $('.answers .vote').bind 'ajax:success', (e, data, status, xhr) ->
    answer_id = $(this).data('answerId')
    voting_result = $.parseJSON(xhr.responseText)
    $('#answer-' + answer_id + ' .voting_result').html('<b>' + voting_result + '</b>')
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(hxr.responseText)
    $.each errors, (index, value) ->
      $('#answer-' + answer_id + ' .answer-errors').html(value)

  $('.answers .vote-link').click (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
    $('#answer-' + answer_id + ' .vote-link').hide();
    $('#answer-' + answer_id + ' .reset-vote-link').show();

  $('.answers .reset-vote-link').click (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
    $('#answer-' + answer_id + ' .reset-vote-link').hide();
    $('#answer-' + answer_id + ' .vote-link').show();

  questionId = $('.answers').data('questionId');
  PrivatePub.subscribe '/questions/' + questionId + '/answer', (data, channel) ->
    answer = $.parseJSON(data['answer']);
    $('#notice').html(answer.flash_notice);
    $('textarea#answer_body').val('');
    $('.answer-errors').empty();
    $('.answers').append(JST["answer"]({answer: answer}));


$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
