//= require jquery
//= require jquery_ujs
//= require_tree .
  
$(document).ready(function() {
  $(document).find('.field input').each(function(index) {
    $(this).focus(function() {
      if ($(this).parent().attr('class') == 'field_with_errors') { 
        $(this).parent().parent().addClass('active');
      } else { 
        $(this).parent().addClass('active');
      }
      $("label[for='" + $(this).attr('id') + "']").hide();
    });
    $(this).blur(function() { 
      if ($(this).parent().attr('class') == 'field_with_errors') {
        $(this).parent().parent().removeClass('active');
      } else { 
        $(this).parent().removeClass('active');
      }
      if ($(this).val() == "") {
        $("label[for='" + $(this).attr('id') + "']").show();
      }
    });
  });
});

$(document).ready(function() {
  $(document).find('.field label').each(function(index) {
    if ($('#' + $(this).attr('for')).val() != "") {
      $(this).hide();
    }
    $(this).live('click', function(e) {
      $('#' + $(this).attr('for')).focus();
      $(this).hide();
    });
  });
});

$(document).ready(function() {
  $(document).find('#error_explanation li').each(function(index) {
    $(this).css('top', $('#' + $(this).attr('for')).position().top);
    $(this).css('left', - $(this).width() - 15);
  });
});


