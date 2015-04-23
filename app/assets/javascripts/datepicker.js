// DatePicker
//
// method configures datepicker
// https://github.com/Nerian/bootstrap-datepicker-rails
//
// Online example good for finding options
// http://eternicode.github.io/bootstrap-datepicker/
//
$(document).on("page:load ready", function(){
  $('input.date_picker').datepicker({
    autoclose: true,
    format: 'dd/mm/yyyy',
    todayBtn: "linked",
    todayHighlight: true
  });
});