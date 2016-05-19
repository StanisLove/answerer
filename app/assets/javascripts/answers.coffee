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
    $('.answers > div > h3').html("Ответ");
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('#answer-' + answer_id + ' > h3').html("Лучший ответ");



    
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
