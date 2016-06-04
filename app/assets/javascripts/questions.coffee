# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();

  $('.edit-question-button').click ->
    $('.edit_question').hide();
    $('.edit-question-link').show();

  $('.question .vote').bind 'ajax:success', (e, data, status, xhr) ->
    voting_result = $.parseJSON(xhr.responseText)
    $('.question .voting_result').html('<b>' + voting_result + '</b>')
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(hxr.responseText)
    $.each errors, (index, value) ->
      $('.question-errors').html(value)

  $('.question .vote-link').click (e) ->
    e.preventDefault();
    $('.question .vote-link').hide();
    $('.question .reset-vote-link').show();

  $('.question .reset-vote-link').click (e) ->
    e.preventDefault();
    $('.question .reset-vote-link').hide();
    $('.question .vote-link').show();

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions').append('<div class="question-' + question.id + '">')
    $('.questions').append('<h3>' + question.title + '</h3>')
    $('.questions').append('<a href="/questions/' + question.id + '"> Открыть вопрос </a>')
    $('.questions').append('<p>' + question.body + '</p>')
    $('.questions').append('<a href="/questions/' + question.id + '/answers/new"> Написать ответ </a>')


$(document).ready(ready)
