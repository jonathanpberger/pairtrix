var TeamsShow = {
  init: function () {
    var teamId = $(".matrix-table").data("team-id"),
    railsEnv = $("body").data("rails-env"),
    channel = pusher.subscribe('private-' + railsEnv + '-team-' + teamId);

    channel.bind("addPair", function (data) {
      TeamsShow.updateTeamMatrix(data);
    });

    channel.bind("removePair", function (data) {
      TeamsShow.updateTeamMatrix(data);
    });
  },

  updateTeamMatrix: function (data) {
    var uuid = $(".matrix-table").data("uuid"),
    checksum = $(".matrix-table").data("checksum"),
    clickedCell;

    if (uuid !== data.uuid) {
      if (checksum === data.checksum) {
        clickedCell = $(".matrix-cell[data-pair-memberships='" + data.pairMemberString + "']");
        window.updateMatrix(clickedCell, data.pairId || null);
      } else {
        TeamsShow.showAlert();
      }
    }
  },

  showAlert: function () {
    var alert = $("<div>").addClass("alert").addClass("alert-error").html("Team is out of date, reloading...");
    alert.appendTo("#flash-messages");
    setTimeout(function () { location.reload(true); }, 3000);
  }
};
