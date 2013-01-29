class UsersDashboard
  init: ->
    $('#user_sign_in_redirect_option').change ->
      form = $(this).closest('form');
      $.post(form.attr('action'), form.serialize() + "&format=json");

namespace "Pairtrix", (exports) ->
  exports.UsersDashboard = UsersDashboard
