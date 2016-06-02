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

  $('.question .vote-link').click (e) ->
    e.preventDefault();
    $('.question .vote-link').hide();
    $('.question .reset-vote-link').show();

  $('.question .reset-vote-link').click (e) ->
    e.preventDefault();
    $('.question .reset-vote-link').hide();
    $('.question .vote-link').show();


$(document).ready(ready)
