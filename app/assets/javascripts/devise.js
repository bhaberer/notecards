
$(document).ready(function() {
  $('#signin_form form').ajaxError(function() {
    $('.formError').hide();
    $('.formError').replaceWith('<div class="formError">Invalid username or password!</div>');
    $('.formError').show();
  });
});
