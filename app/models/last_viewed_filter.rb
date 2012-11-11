class LastViewedFilter
  def self.filter(controller)
    current_user = controller.send(:current_user)
    request_method = controller.request.method

    if current_user && current_user.save_last_viewed_url? && request_method == 'GET'
      requested_url = controller.request.url
      current_user.update_attributes(last_viewed_url: requested_url) if (requested_url !~ /sign_out/)
    end
  end
end
