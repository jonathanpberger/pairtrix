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
    var teamId = team.closest('.team').data('team-id');
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
    var teamHtml = $("<div/>", {class: "team", "data-team-id": team.id}).data('team-id', team.id).html(
      $("<div/>", {class: "heading"}).html(
        $("<h5/>").html(
          $("<a/>", { text: team.name,
            href: "/teams/"+team.id})))
    ).append(
    $("<ul/>", {class: "team-memberships ui-droppable"})
    .droppable({
      accept: ".available-employee, .team-membership",
      hoverClass: "ui-hover",
      drop: function(event, ui) {
        createTeamMembership($(ui.draggable[0]), $(this));
      }
    }));
    $(".team").parent().append(teamHtml);
  }

  function addEmployee(employee) {
    var fullName = employee.first_name+" "+employee.last_name;
    var imageUrl = employee.avatar.url || "/assets/layout/avatar.png";
    var employeeHtml = $("<li/>", {class: "available-employee ui-draggable"}).html(
      $("<div/>", {class: "employee-badge badge", "data-employee-id": employee.id}).data('employee-id', employee.id).html(
        $("<div/>", {class: "avatar"}).html(
          $("<img/>", { alt: fullName, src: imageUrl}))
    ).append($("<div/>", {class: "employee-name", text: fullName}))
    ).draggable(draggableParams);
    $(".available-employees").find('ul').append(employeeHtml);
  }

  function addError(prefix, field, message) {
    var inputField = $("#"+prefix+"_"+field);
    inputField.closest(".control-group").addClass("error");
    inputField.closest(".controls").append($("<span/>", {class:'help-inline', text: message}));
  }

  function displayErrors(modelName, form, result) {
    var errors = $.parseJSON(result.responseText).errors;
    $.each(errors, function(field, message) {
      addError(modelName, field, message);
    });
  }

  function removeErrors(form) {
    var controlGroup = form.find(".control-group");
    controlGroup.removeClass("error");
    controlGroup.find('.controls').each(function() {
      $(this).find('span').remove();
    });
  }

  function resetForm(form) {
    form[0].reset();
    removeErrors(form);
  }

  $('#addEmployee').on('show', function() {
    resetForm($(this).find('form'));
  });

  $('#addTeam').on('show', function() {
    resetForm($(this).find('form'));
  });

  $('#new_team_ajax').on('submit', function(){
    var form = $(this);
    var formData = new FormData(form[0]);
    removeErrors(form);
    $.ajax({
      url: form.attr('action'),  //server script to process data
      type: 'POST',
      beforeSend: function(xhr) {
        xhr.setRequestHeader("Accept", "application/json");
      },
      success: function(team) {
        addTeam(team);
        $("#addTeam").modal('hide');
      },
      error: function(result) {
        displayErrors("team", form, result);
      },
      data: formData,
      cache: false,
      contentType: false,
      processData: false
    });
    return false;
  });

  $('#add-team-submit').on('click', function(e){
    e.preventDefault();
    $('#new_team_ajax').submit();
  });

  $('#new_employee_ajax').on('submit', function(){
    var form = $(this);
    removeErrors(form);
    var formData = new FormData(form[0]);
    $.ajax({
      url: form.attr('action'),  //server script to process data
      type: 'POST',
      beforeSend: function(xhr) {
        xhr.setRequestHeader("Accept", "application/json");
      },
      success: function(employee) {
        addEmployee(employee);
        $("#addEmployee").modal('hide');
      },
      error: function(result) {
        displayErrors("employee", form, result);
      },
      data: formData,
      cache: false,
      contentType: false,
      processData: false
    });
    return false;
  });

  $('#add-employee-submit').on('click', function(e){
    e.preventDefault();
    $('#new_employee_ajax').submit();
  });

  $(".available-employees li").draggable(draggableParams);
  $(".team li").draggable(draggableParams);

  $(".team ul").droppable({
    accept: ".available-employee, .team-membership",
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

  function deleteTeam(options) {
    var team = options.$trigger.closest('.team');
    var teamId = team.data('team-id');
    if (confirm("Are you sure?")) {
      $.ajax({
        url: '/teams/'+teamId,
        type: 'POST',
        beforeSend: function(xhr) {
          xhr.setRequestHeader("Accept", "application/json");
        },
        success: function(employee) {
          var availableEmployees = $(".available-employees ul");
          $(team).find('.team-membership').each(function() {
            addAvailableEmployee($(this), availableEmployees);
          });
          $(team).remove();
        },
        data: {_method: 'DELETE'}
      });
    }
  }

  $.contextMenu({
    selector: ".team h5",
    items: {
      'delete': {
        name: "Delete Team",
        callback: function(key, opt){ deleteTeam(opt); },
        icon: 'delete'
      }
    }
  });
});
