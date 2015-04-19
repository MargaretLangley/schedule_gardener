// DatePicker
//
// method configures datepicker
// https://github.com/Nerian/bootstrap-datepicker-rails
//
$(document).on("page:load ready", function(){
  $('input.date_picker').datepicker({
    format: 'dd/mm/yyyy',
    autoclose: true
  });
});