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

$(document).ready(ready)
