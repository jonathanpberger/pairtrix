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

  function addPair(clickedCell) {
    var pairMemberIds = clickedCell.data("pair-memberships").split(",");
    var teamId = $(".matrix-table").data("team-id");
    $.post("/pairs/ajax_create", { 'pair[team_membership_ids][]': pairMemberIds, team_id: teamId, format: 'json' },
           function(json) {
             clickedCell.data("pair-id", json.pairId);
           });
  }

  function removePair(clickedCell) {
    var pairId = clickedCell.data("pair-id");
    $.post("/pairs/"+pairId, { _method: 'delete', format: 'json' },
           function(json) {
             clickedCell.removeData("pair-id");
           });
  }

  function updateCellCount(clickedCell, difference) {
    var count = parseInt(clickedCell.text()) + difference;
    clickedCell.text(count);
  }

  $(".matrix-row-paired-count").click(function() {
    var clickedCell = $(this);
    if (!clickedCell.hasClass("faded")) {

      var pairMemberIds = clickedCell.data("pair-memberships").split(",");
      var pairedMembershipIds = $(".matrix-table").data("paired-memberships");

      if (clickedCell.hasClass("created-pair")) {
        removePair(clickedCell);
        updateCellCount(clickedCell, -1);
        updatePairedMemberships(removePairIds(pairedMembershipIds, pairMemberIds));
        clickedCell.removeClass("created-pair").removeClass("faded");
      } else {
        addPair(clickedCell);
        updateCellCount(clickedCell, 1);
        updatePairedMemberships(pairedMembershipIds.concat(pairMemberIds));
        clickedCell.addClass("created-pair").removeClass("faded");
      }
    }
  });

  modifyPairMemberCells();
});
