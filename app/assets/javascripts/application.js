//= require jquery
//= require jquery_ujs
//= require_tree .
  
function deviseAjax() {
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
  $(document).find('.field label').each(function(index) {
    if ($('#' + $(this).attr('for')).val() != "") {
      $(this).hide();
    }
    $(this).live('click', function(e) {
      $('#' + $(this).attr('for')).focus();
      $(this).hide();
    });
  });
};

function moveErrors() {
  $(document).find('.devise #error_explanation li').each(function(index) {
    $(this).css('top', $('#' + $(this).attr('for')).position().top);
    $(this).css('left', - $(this).width() - 15);
    $(this).fadeIn();
  });
  $(document).find('li[for="card_entry"]').each(function(index) {
    $(this).css('top', $('#' + $(this).attr('for')).position().top);
    $(this).css('left', $(this).position().left - 130);
    $(this).fadeIn();
  });
};

$(document).ready(function() {
  moveErrors();
  deviseAjax();
});

// Bunch of generic ajax helpers

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  }
});

function _ajax_request(url, data, callback, type, method) {
  if (jQuery.isFunction(data)) {
      callback = data;
      data = {};
  }
  return jQuery.ajax({
    type: method,
    url: url,
    data: data,
    success: callback,
    dataType: type
  });
};

jQuery.extend({
  put: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'PUT');
  },
  delete_: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'DELETE');
  }
});

jQuery.fn.submitWithAjax = function() {
  this.unbind('submit', false);
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    $("#form_spinner").fadeIn();
    return false;
  })
  return this;
};

jQuery.fn.searchWithAjax = function() {
  this.unbind('submit', false);
  this.submit(function() {
    $.get(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.getWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    $.get($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.postWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    $.post($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.putWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    $.put($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.deleteWithAjax = function() {
  this.removeAttr('onclick');
  this.unbind('click', false);
  this.click(function() {
    $.delete_($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

function ajaxLinks() {
  $('.ajaxForm').submitWithAjax();
  $('.searchForm').searchWithAjax();
  $('a.get').getWithAjax();
  $('a.post').postWithAjax();
  $('a.put').putWithAjax();
  $('a.delete').deleteWithAjax();
}

$(document).ready(function() {
  // All non-GET requests will add the authenticity token
  $(document).ajaxSend(function(event, request, settings) {
    if (typeof(window.AUTH_TOKEN) == "undefined") return;
    // IE6 fix for http://dev.jquery.com/ticket/3155
    if (settings.type == 'GET' || settings.type == 'get') return;
    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
  });
  ajaxLinks();
});


