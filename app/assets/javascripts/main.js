$(function () {
  "use strict";

  var page = $("body").data("page"),
  pusherKey =  $("body").data("pusher-key");

  window.pusher = new Pusher(pusherKey);

  if ("object" === typeof(window[page])) {
    window[page].init();
  }

  $(".datepicker").datepicker({"autoclose": true});

  // display the loading graphic during ajax requests
  $("#loading").ajaxStart(function () {
    $(this).show();
  }).ajaxStop(function () {
    $(this).hide();
  });

  // make sure we accept javascript for ajax requests
  jQuery.ajaxSetup({'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript"); }});
});
