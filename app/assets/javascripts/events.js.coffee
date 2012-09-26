# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#appointment_event_attributes_starts_at').datetimepicker
    dateFormat: 'yy-mm-dd'

jQuery ->
  $('#appointment_event_attributes_ends_at').datetimepicker
    dateFormat: 'yy-mm-dd'