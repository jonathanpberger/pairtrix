$(function () {
  var fc;

  Array.prototype.shuffle = function () {
    var i = this.length, j, tempi, tempj;
    if (i === 0) return false;
    while (--i) {
      j       = Math.floor(Math.random() * (i + 1));
      tempi   = this[i];
      tempj   = this[j];
      this[i] = tempj;
      this[j] = tempi;
    }
    return this;
  };

  function setRandomPairButtonStatus() {
    if (availableCellCount() === 0) {
      $(".randomize-pairs").attr("disabled", "disabled");
    } else {
      $(".randomize-pairs").removeAttr("disabled");
    }
  }

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

  window.updateMatrix = function updateMatrix(clickedCell, pairId) {
    var pairingInformation = getPairingInformation(clickedCell),
    count,
    modifiedMemberships;

    if (pairId) {
      clickedCell.data("pair-id", pairId);
      count = 1;
      modifiedMemberships = pairingInformation.pairedMembershipIds.concat(pairingInformation.pairMemberIds);
    } else {
      clickedCell.removeData("pair-id");
      count = -1;
      modifiedMemberships = removePairIds(pairingInformation.pairedMembershipIds, pairingInformation.pairMemberIds);
    }
    clickedCell.toggleClass("created-pair").removeClass("faded");
    updateCellCount(clickedCell, count);
    updatePairedMemberships(modifiedMemberships);
    setRandomPairButtonStatus();
  };

  function addPair(clickedCell) {
    var pairMemberString = clickedCell.data("pair-memberships"),
    pairMemberIds = pairMemberString.split(","),
    teamId = $(".matrix-table").data("team-id"),
    uuid = $(".matrix-table").data("uuid");

    $.post("/pairs/ajax_create",
           { 'pair[team_membership_ids][]': pairMemberIds, team_id: teamId, uuid: uuid, format: 'json' },
           function (json) {
             if (json.success === true) {
               window.updateMatrix(clickedCell, json.pairId);
             } else {
               notAuthorized();
             }
           });
  }

  function removePair(clickedCell) {
    var pairId = clickedCell.data("pair-id"),
    uuid = $(".matrix-table").data("uuid");

    $.post("/pairs/" + pairId,
           { uuid: uuid, _method: 'delete', format: 'json' },
           function (json) {
             if (json.success === true) {
               window.updateMatrix(clickedCell, null);
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

  function getUnpairedCells() {
    var unpairedCells, timesPairedCount;
    timesPairedCount = -1;
    do {
      timesPairedCount++;
      unpairedCells = $(".paired-count:not(.no-automation):not(.faded):not(.created-pair):contains(" + timesPairedCount + ")");
    }
    while (unpairedCells.length === 0);
    return unpairedCells;
  }

  function flashCells(items, delay, count) {
    setTimeout(function () {
      items.toggleClass("possible-pair");
      count--;
      if (count !== 0) {
        flashCells(items, delay, count);
      } else {
        fc(items.get());
      }
    }, delay);
  }

  function flashCell(cells, cell, delay, count, isLast) {
    setTimeout(function () {
      $(cell).toggleClass("possible-pair");
      count--;
      if (count !== 0) {
        flashCell(cells, cell, delay, count, isLast);
      } else {
        if (isLast) {
          addPair($(cell));
        } else {
          fc(cells);
        }
      }
    }, delay);
  }

  fc = function (cells) {
    var cell;
    cells.shuffle();
    cell = cells.pop();
    flashCell(cells, cell, 50, 2, (cells.length === 0));
  };

  function generatePair() {
    var unpairedCells = getUnpairedCells();
    flashCells(unpairedCells, 250, 4);
  }

  function buildAvailablePair() {
    if (availableCellCount() > 0) {
      generatePair();
    }
  }

  $(".randomize-pairs").bind("click", function () {
    $(this).attr("disabled", "disabled");
    buildAvailablePair();
  });

  if ($(".matrix-table").length > 0) {
    modifyPairMemberCells();
    setRandomPairButtonStatus();
  }
});
