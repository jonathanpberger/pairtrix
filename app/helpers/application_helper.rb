# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  FLASH_NOTICE_KEYS = [:success, :notice, :warning, :failure, :error, :invalid, :alert, :unauthenticated, :unconfirmed, :invalid_token, :timeout, :inactive, :locked]

  def flash_messages
    return unless messages = flash.keys.select{|k| FLASH_NOTICE_KEYS.include?(k)}
    formatted_messages = messages.map do |type|
      content_tag(:div, class: "alert alert-#{type}") do
        content_tag(:a, "x", class: 'close', "data-dismiss" => 'alert') +
        message_for_item(flash[type], flash["#{type}_item".to_sym])
      end
    end
    flash.clear
    formatted_messages.join
  end

  def message_for_item(message, item = nil)
    if item.is_a?(Array)
      message % link_to(*item)
    else
      message % item
    end
  end

  def error_messages_for(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = "#{pluralize(resource.errors.count, "error")} prohibited this #{resource.class.name.downcase} from being saved:"

    html = content_tag(:div, :class => 'error-explanation') do
      content_tag(:h3, sentence) +
        content_tag(:ul, messages.html_safe)
    end
    html.html_safe
  end

  def yes_no(bool)
    bool ? "Yes" : "No"
  end

  def pairing_count_warning(times_paired)
    case
    when times_paired == 3
      "pairing-count-notice"
    when times_paired > 3
      "pairing-count-warning"
    else
      ""
    end
  end

  def avatar_for(employee)
    image_url = employee.avatar? ? employee.avatar_url : "layout/avatar.png"
    image_tag(image_url, title: employee.name, alt: employee.name)
  end

  def pair_cell(pair_group)
    content_tag(:td,
                times_paired(pair_group),
                class: pair_cell_css_classes(pair_group),
                data: { pair: pair_group.ids })
  end

  private

  def pair_cell_css_classes(pair_group)
    klasses = ["matrix-row-paired-count"]
    klasses << pairing_count_warning(times_paired(pair_group))
    klasses << "member-#{pair_group.left_membership.id}"
    klasses << "member-#{pair_group.top_membership.id}"
    klasses << "created-pair" if pair_group.current_pair?
    klasses.join(" ")
  end

  def times_paired(pair_group)
    pair_group.team.times_paired(pair_group.left_membership, pair_group.top_membership)
  end
end
