// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
  
$(document).ready(function() {
  $(document).find('.field input').each(function(index) {
    $(this).focus(function() { 
      $(this).parent().addClass('active');
      $(this).next().hide();
    });
    $(this).blur(function() { 
      $(this).parent().removeClass('active');
      if ($(this).val() == "") {
        $(this).next().show();
      }
    });
  });
});

$(document).ready(function() {
  $(document).find('.field span').each(function(index) {
    if ($(this).prev().val() != "") {
      $(this).hide();
    }
    $(this).live('click', function(e) {
      $(this).hide();
      $(this).prev().focus();
    });
  });
});


