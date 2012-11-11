$(function() {

  var draggableParams = { revert: true, zIndex: 300 };

  var updateClasses = function(newTeam) {
    var addClass, removeClass;
    if (newTeam === true) {
      addClass = "team-membership";
      removeClass = "available-employee";
    } else {
      addClass = "available-employee";
      removeClass = "team-membership";
    }
    return {
      'addClass' : addClass,
      'removeClass': removeClass
    }
  }

  function getEmployeeId(element) {
    return element.find('.employee-badge').data('employee-id');
  }

  function unableToCompleteAction() {
    $("#flash-messages").html("<div class='alert alert-error'>Unable to complete that operation.</div>").show().delay(2000).fadeOut("fast");
  }

  function addAvailableEmployee(teamMembership, availableEmployees) {
    var cssClasses = updateClasses(false);
    teamMembership.
      remove().
      clone(true).
      css('position', 'inherit').
      addClass(cssClasses.addClass).
      removeClass(cssClasses.removeClass).
      removeAttr('style').
      appendTo(availableEmployees).
      draggable(draggableParams);
  }

  function addTeamMember(employee, team, teamMembershipId) {
    var cssClasses = updateClasses(true);
    employee.
      remove().
      clone(true).
      css('position', 'inherit').
      addClass(cssClasses.addClass).
      removeClass(cssClasses.removeClass).
      removeAttr('style').
      data('team-membership-id', teamMembershipId).
      appendTo(team).
      draggable(draggableParams);
  }

  function createAvailableEmployee(teamMembership, availableEmployees) {
    var teamMembershipId = teamMembership.data('team-membership-id');
    $.post("/team_memberships/"+teamMembershipId,
           { format: 'json', _method: 'delete' },
           function() {
             addAvailableEmployee(teamMembership, availableEmployees);
           }).
             error(function() {
             unableToCompleteAction();
           });
  }

  function createTeamMembership(employee, team) {
    var teamId = team.data('team-id');
    var employeeId = getEmployeeId(employee);
    $.post("/teams/"+teamId+"/team_memberships",
           { 'team_membership[employee_id]': employeeId, format: 'json' },
           function(teamMembership) {
             addTeamMember(employee, team, teamMembership.id);
           }).
             error(function() {
             unableToCompleteAction();
           });
  }

  function addTeam(team) {
    var teamHtml = $("<div/>", {class: "team"}).html(
      $("<div/>", {class: "heading"}).html(
        $("<h5/>").html(
          $("<a/>", { text: team.name,
            href: "/teams/"+team.id})))).append(
            $("<ul/>", {class: "team-memberships ui-droppable", "data-team-id": team.id}).data('team-id', team.id)
            .droppable({
              accept: ".available-employee",
              hoverClass: "ui-hover",
              drop: function(event, ui) {
                createTeamMembership($(ui.draggable[0]), $(this));
              }
            }));
            $(".team").parent().append(teamHtml);
  }

  $('#new_team_ajax').on('submit', function(){
    var form = $(this);
    form.find(".control-group").removeClass("error").find(".controls").find('span').remove();
    $.post(form.attr('action'), form.serialize()+"&format=json", function(team) {
      addTeam(team);
      $("#addTeam").modal('hide');
    }).error(function(result) {
      var json = JSON.parse(result.responseText);
      form.find(".control-group").addClass("error").
        find(".controls").append($("<span/>", {class:'help-inline', text: json.errors.name[0]}));
    });
    return false;
  });

  $('#add-team-submit').on('click', function(e){
    // We don't want this to act as a link so cancel the link action
    e.preventDefault();
    $('#new_team_ajax').submit();
  });

  $(".available-employees li").draggable(draggableParams);
  $(".team li").draggable(draggableParams);

  $(".team ul").droppable({
    accept: ".available-employee",
    hoverClass: "ui-hover",
    drop: function(event, ui) {
      createTeamMembership($(ui.draggable[0]), $(this));
    }
  });

  $(".available-employees ul").droppable({
    accept: ".team-membership",
    hoverClass: "ui-hover",
    drop: function(event, ui) {
      createAvailableEmployee($(ui.draggable[0]), $(this));
    }
  });
});
