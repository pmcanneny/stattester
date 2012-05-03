// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//jQuery.noConflict();

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

$.fn.subSelectWithAjax = function() {
  var that = this;

  this.change(function() {
    $.post(that.attr('rel'), {id: that.val()}, null, "script");
  });
};

$(document).ready(function() {
  //$("#data_update").submitWithAjax();
  $("#sic_1").subSelectWithAjax();
  $("#sic_2").subSelectWithAjax();
  $("#sic_3").subSelectWithAjax();
  $("#sic_row2").hide();
  $("#sic_row3").hide();
})


