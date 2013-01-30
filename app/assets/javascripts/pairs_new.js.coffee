namespace "Pairtrix", (exports) ->
  class exports.PairsNew
    init: ->
      $("input[type=checkbox][name='pair[team_membership_ids][]']").click ->
        bol = $("input[type=checkbox][name='pair[team_membership_ids][]']:checked").length >= 2
        $("input[type=checkbox][name='pair[team_membership_ids][]']").not(":checked").attr("disabled", bol)

