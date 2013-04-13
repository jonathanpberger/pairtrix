namespace "Pairtrix", (exports) ->
  class exports.Matrix
    init: ->

    @hideRestrictedIfNoRestrictions: ->
      if Matrix.getRestrictedIds().length is 0
        $(".pair-restricted").hide()

    @setRandomPairButtonStatus: ->
      if Matrix.availableCellCount() is 0
        $(".randomize-pairs").attr "disabled", "disabled"
        $(".pair-restricted").attr "disabled", "disabled"
      else
        $(".randomize-pairs").removeAttr "disabled"
        $(".pair-restricted").removeAttr "disabled"
      if not Matrix.restrictedPairingPossible()
        $(".pair-restricted").attr "disabled", "disabled"

    @modifyPairMemberCells: ->
      pairedMembershipIds = $(".matrix-table").data("paired-memberships")
      outOfOfficeMembershipId = $(".matrix-table").data("out-of-office-membership-id").toString()
      $(".matrix-table .matrix-cell").removeClass "faded"
      $.each pairedMembershipIds, (index, pairMembershipId) ->
        if pairMembershipId isnt outOfOfficeMembershipId
          $(".matrix-table").find(".member-#{pairMembershipId}").each ->
            $(this).addClass "faded" unless $(this).hasClass("created-pair")

    @removePairIds: (pairedMembershipIds, pairMemberIds) ->
      $.each pairMemberIds, (index, pairMemberId) ->
        pairedMembershipIds.splice pairedMembershipIds.indexOf(pairMemberId), 1
      pairedMembershipIds

    @updatePairedMemberships: (pairedMembershipIds) ->
      $(".matrix-table").data "paired-memberships", pairedMembershipIds
      Matrix.modifyPairMemberCells()

    @notAuthorized:  ->
      $("#flash-messages").html("<div class='alert alert-error'>You are not authorized to complete this action.</div>").show().delay(2000).fadeOut "fast"

    @noAvailablePairs:  ->
      $("#flash-messages").html("<div class='alert alert-error'>There are no available restricted/pairable combinations.</div>").show().delay(2000).fadeOut "fast"

    @addPair: (clickedCell) ->
      pairMemberString = clickedCell.data("pair-memberships")
      pairMemberIds = pairMemberString.split(",")
      teamId = $(".matrix-table").data("team-id")
      uuid = $(".matrix-table").data("uuid")
      $.post "/pairs/ajax_create",
        "pair[team_membership_ids][]": pairMemberIds
        team_id: teamId
        uuid: uuid
        format: "json"
      , (json) ->
        if json.success is true
          Matrix.updateMatrix clickedCell, json.pairId
        else
          Matrix.notAuthorized()

    @removePair: (clickedCell) ->
      pairId = clickedCell.data("pair-id")
      uuid = $(".matrix-table").data("uuid")
      $.post "/pairs/#{pairId}",
        uuid: uuid
        _method: "delete"
        format: "json"
      , (json) ->
        if json.success is true
          Matrix.updateMatrix clickedCell, null
        else
          Matrix.notAuthorized()

    @updateCellCount: (clickedCell, difference) ->
      count = parseInt(clickedCell.text(), 10) + difference
      clickedCell.text count

    @getPairingInformation: (clickedCell) ->
      pairingInformation = {}
      pairingInformation.pairMemberIds = clickedCell.data("pair-memberships").split(",")
      pairingInformation.pairedMembershipIds = $(".matrix-table").data("paired-memberships")
      pairingInformation

    @availableCellCount: ->
      $(".paired-count:not(.no-automation):not(.faded):not(.created-pair)").length

    @getUnpairedCells: ->
      timesPairedCount = -1
      loop
        timesPairedCount++
        unpairedCells = $(".paired-count:not(.no-automation):not(.faded):not(.created-pair):contains(\"#{timesPairedCount}\")")
        break unless unpairedCells.length is 0
      unpairedCells

    @flashCells: (items, delay, count) ->
      setTimeout (->
        items.toggleClass "possible-pair"
        count--
        if count isnt 0
          Matrix.flashCells items, delay, count
        else
          Matrix.flash items.get()
      ), delay

    @flashCell: (cells, cell, delay, count, isLast) ->
      setTimeout (->
        $(cell).toggleClass "possible-pair"
        count--
        if count isnt 0
          Matrix.flashCell cells, cell, delay, count, isLast
        else
          if isLast
            Matrix.addPair $(cell)
          else
            Matrix.flash cells
      ), delay

    @generatePair: ->
      unpairedCells = Matrix.getUnpairedCells()
      Matrix.flashCells unpairedCells, 250, 4

    @buildAvailablePair: ->
      Matrix.generatePair() if Matrix.availableCellCount() > 0

    @getRestrictedIds: ->
      $("*[data-member=true]").filter(".do-not-pair").map(->
        return $(this).data("membership-id")
      )

    @getPairableIds: ->
      $("*[data-member=true]").not(".do-not-pair").map(->
        return $(this).data("membership-id")
      )

    @getPairedIds: ->
      if $(".created-pair").length > 0
        pairedIds = _.uniq($(".created-pair").map(->
          return $(this).data("pair-memberships").split(',')
        )).map((num)->
          return parseInt(num)
        )
      else
        pairedIds = []
      pairedIds

    @getRestrictedIdPool: ->
      _.difference(Matrix.getRestrictedIds(), Matrix.getPairedIds())

    @getPairableIdPool: ->
      _.difference(Matrix.getPairableIds(), Matrix.getPairedIds())

    @addRestrictedPair:(restrictedIdPool, pairableIdPool) ->
      restrictedId = Matrix.returnRandom(restrictedIdPool)
      pairableId = Matrix.returnRandom(pairableIdPool)
      pairing = [restrictedId, pairableId].sort()
      cellToPair = $("div[data-pair-memberships='#{pairing.toString()}']")
      Matrix.addPair(cellToPair)

    @returnRandom: (array) ->
      array.shuffle()
      array.pop()

    @restrictedPairingPossible: ->
      (Matrix.getPairableIdPool().length > 0) && (Matrix.getRestrictedIdPool().length > 0)

    @buildRestrictedPair: ->
      if (Matrix.restrictedPairingPossible())
        Matrix.addRestrictedPair(Matrix.getRestrictedIdPool(), Matrix.getPairableIdPool())
      else
        Matrix.noAvailablePairs()

    @updateMatrix: (clickedCell, pairId) ->
      pairingInformation = Matrix.getPairingInformation(clickedCell)
      if pairId
        clickedCell.data "pair-id", pairId
        count = 1
        modifiedMemberships = pairingInformation.pairedMembershipIds.concat(pairingInformation.pairMemberIds)
      else
        clickedCell.removeData "pair-id"
        count = -1
        modifiedMemberships = Matrix.removePairIds(pairingInformation.pairedMembershipIds, pairingInformation.pairMemberIds)
      clickedCell.toggleClass("created-pair").removeClass "faded"
      Matrix.updateCellCount clickedCell, count
      Matrix.updatePairedMemberships modifiedMemberships
      Matrix.setRandomPairButtonStatus()

    @flash: (cells) ->
      cells.shuffle()
      cell = cells.pop()
      Matrix.flashCell cells, cell, 50, 2, (cells.length is 0)
