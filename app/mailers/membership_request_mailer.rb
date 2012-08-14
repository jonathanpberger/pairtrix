class MembershipRequestMailer < ActionMailer::Base
  default from: "noreply@pairtrix.com"

  def membership_request_email(membership_request)
    @user = membership_request.user
    @company = membership_request.company
    mail(to: membership_request.company.user.email, subject: "[MEMBERSHIP REQUEST] for #{@company.name} from #{@user.name}")
  end
end
