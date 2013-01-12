$(function () {

  function modifyPairMemberCells() {
    var pairedMembershipIds = $(".matrix-table").data("paired-memberships"),
    outOfOfficeMembershipId = $(".matrix-table").data("out-of-office-membership-id").toString();

    $(".matrix-table .matrix-cell").removeClass("faded");
    $.each(pairedMembershipIds, function (index, pairMembershipId) {
      if (pairMembershipId !== outOfOfficeMembershipId) {
        $(".matrix-table").find(".member-" + pairMembershipId).each(function () {
          if (!$(this).hasClass("created-pair")) {
            $(this).addClass("faded");
          }
        });
      }
    });
  }

  function removePairIds(pairedMembershipIds, pairMemberIds) {
    $.each(pairMemberIds, function (index, pairMemberId) {
      pairedMembershipIds.splice(pairedMembershipIds.indexOf(pairMemberId), 1);
    });
    return pairedMembershipIds;
  }

  function updatePairedMemberships(pairedMembershipIds) {
    $(".matrix-table").data("paired-memberships", pairedMembershipIds);
    modifyPairMemberCells();
  }

  function notAuthorized() {
    $("#flash-messages").html("<div class='alert alert-error'>You are not authorized to complete this action.</div>").show().delay(2000).fadeOut("fast");
  }

  function addPair(clickedCell) {
    var pairMemberIds = clickedCell.data("pair-memberships").split(","),
    teamId = $(".matrix-table").data("team-id");
    $.post("/pairs/ajax_create", { 'pair[team_membership_ids][]': pairMemberIds, team_id: teamId, format: 'json' },
           function (json) {
              if (json.success === true) {
                var pairingInformation = getPairingInformation(clickedCell);
                clickedCell.data("pair-id", json.pairId);
                updateCellCount(clickedCell, 1);
                clickedCell.addClass("created-pair").removeClass("faded");
                updatePairedMemberships(pairingInformation.pairedMembershipIds.concat(pairingInformation.pairMemberIds));
              } else {
                notAuthorized();
              }
            });
  }

  function removePair(clickedCell) {
    var pairId = clickedCell.data("pair-id");
    $.post("/pairs/" + pairId, { _method: 'delete', format: 'json' },
           function (json) {
              if (json.success === true) {
                var pairingInformation = getPairingInformation(clickedCell);
                clickedCell.removeData("pair-id");
                updateCellCount(clickedCell, -1);
                clickedCell.removeClass("created-pair").removeClass("faded");
                updatePairedMemberships(removePairIds(pairingInformation.pairedMembershipIds, pairingInformation.pairMemberIds));
              } else {
                notAuthorized();
              }
            });
  }

  function updateCellCount(clickedCell, difference) {
    var count = parseInt(clickedCell.text(), 10) + difference;
    clickedCell.text(count);
  }

  function getPairingInformation(clickedCell) {
    var pairingInformation = {};
    pairingInformation.pairMemberIds = clickedCell.data("pair-memberships").split(",");
    pairingInformation.pairedMembershipIds = $(".matrix-table").data("paired-memberships");
    return pairingInformation;
  }

  $(".paired-count").click(function () {
    var clickedCell = $(this);
    if (!clickedCell.hasClass("faded")) {
      if (clickedCell.hasClass("created-pair")) {
        removePair(clickedCell);
      } else {
        addPair(clickedCell);
      }
    }
  });

  function availableCellCount() {
    return $(".paired-count:not(.no-automation):not(.faded):not(.created-pair)").length;
  }

  function buildAvailablePair() {
    var unpairedCells, timesPairedCount, unpairedCell;

    if (availableCellCount() > 0) {
      timesPairedCount = -1;
      do {
        timesPairedCount++;
        unpairedCells = $(".paired-count:not(.no-automation):not(.faded):not(.created-pair):contains(" + timesPairedCount + ")");
      }
      while (unpairedCells.length === 0);
      unpairedCell = $(unpairedCells[Math.floor(Math.random() * unpairedCells.length)]);
      addPair(unpairedCell);
    }
  }

  $(".randomize-pairs").click(function () {
    buildAvailablePair();
  });

  if ($(".matrix-table").length > 0) {
    modifyPairMemberCells();
  }
});
