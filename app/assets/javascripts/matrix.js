$(function() {

  function modifyPairMemberCells() {
    var pairedMembershipIds = $(".matrix-table").data("paired-memberships");

    $(".matrix-table td").removeClass("faded");
    $.each(pairedMembershipIds, function(index, pairMembershipId) {
      if (pairMembershipId !== "2") {
        $(".matrix-table").find(".member-"+pairMembershipId).each(function() {
          if (!$(this).hasClass("created-pair")) {
            $(this).addClass("faded");
          }
        });
      }
    });
  }

  function removePairIds(pairedMembershipIds, pairMemberIds) {
    $.each(pairMemberIds, function(index, pairMemberId) {
      pairedMembershipIds.splice(pairedMembershipIds.indexOf(pairMemberId), 1);
    });
    return pairedMembershipIds
  }

  function updatePairedMemberships(pairedMembershipIds) {
    $(".matrix-table").data("paired-memberships", pairedMembershipIds);
    modifyPairMemberCells();
  }

  $(".matrix-row-paired-count").click(function() {
    var clickedCell = $(this);
    if (!clickedCell.hasClass("faded")) {

      var pairMemberIds = clickedCell.data("pair").split(",");
      var pairedMembershipIds = $(".matrix-table").data("paired-memberships");

      if (clickedCell.hasClass("created-pair")) {
        updatePairedMemberships(removePairIds(pairedMembershipIds, pairMemberIds));
        clickedCell.removeClass("created-pair").removeClass("faded");
      } else {
        updatePairedMemberships(pairedMembershipIds.concat(pairMemberIds));
        clickedCell.addClass("created-pair").removeClass("faded");
      }
    }
  });

  modifyPairMemberCells();
});
