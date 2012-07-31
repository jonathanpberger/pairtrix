$(function() {
  "use strict";

  $(".datepicker").datepicker({"autoclose": true});

  $("input[type=checkbox][name='pair[team_membership_ids][]']").click(function() {
    var bol = $("input[type=checkbox][name='pair[team_membership_ids][]']:checked").length >= 2;
    $("input[type=checkbox][name='pair[team_membership_ids][]']").not(":checked").attr("disabled", bol);
  });

  // display the loading graphic during ajax requests
  $("#loading").ajaxStart(function(){
     $(this).show();
   }).ajaxStop(function(){
     $(this).hide();
   });

   // make sure we accept javascript for ajax requests
  jQuery.ajaxSetup({'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}});

  $(".matrix-row-paired-count").click(function() {
    var pair = $(this).data("pair");
    $(this).html("changed:"+pair);
    // plan to add some form of ajax call that creates a new pair for the day
    // and returns the total pair count.
    $(this).siblings().addClass("faded");
  });


});
