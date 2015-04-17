// DatePicker
//
// method configures datepicker
// https://github.com/Nerian/bootstrap-datepicker-rails
//
$(function() {
  $('input.date_picker').datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true
  });
});
