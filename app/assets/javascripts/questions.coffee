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
    $('.voting_result').html('<b>' + voting_result + '</b>')

  $('.vote-link').click (e) ->
    e.preventDefault();
    $('.vote-link').hide();
    $('.reset-vote-link').show();

  $('.reset-vote-link').click (e) ->
    e.preventDefault();
    $('.reset-vote-link').hide();
    $('.vote-link').show();


$(document).ready(ready)
