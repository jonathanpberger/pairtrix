class TeamsShow
  init: ->
    teamId = $(".matrix-table").data("team-id")
    railsEnv = $("body").data("rails-env")
    channel = pusher.subscribe("private-" + railsEnv + "-team-" + teamId)
    channel.bind "addPair", (data) ->
      TeamsShow.updateTeamMatrix data

    channel.bind "removePair", (data) ->
      TeamsShow.updateTeamMatrix data

  @updateTeamMatrix: (data) ->
    uuid = $(".matrix-table").data("uuid")
    checksum = $(".matrix-table").data("checksum")
    clickedCell = undefined
    if uuid isnt data.uuid
      if checksum is data.checksum
        clickedCell = $(".matrix-cell[data-pair-memberships='" + data.pairMemberString + "']")
        window.updateMatrix clickedCell, data.pairId or null
      else
        TeamsShow.showAlert()

  @showAlert: ->
    alert = $("<div>").addClass("alert").addClass("alert-error").html("Team is out of date, reloading...")
    alert.appendTo "#flash-messages"
    setTimeout (->
      location.reload true
    ), 3000

namespace "Pairtrix", (exports) ->
  exports.TeamsShow = TeamsShow
