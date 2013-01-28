var UsersDashboard = {
  init: function () {
    $('#user_sign_in_redirect_option').change(function () {
      var form = $(this).closest('form');
      $.post(form.attr('action'), form.serialize() + "&format=json");
    });
  }
};
