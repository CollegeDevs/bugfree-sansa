class NotificationMailer < 	ActionMailer::Base
  default from: "lyvworks@gamil.com"
  def forum_post_notification(user, forum_post)
	@user = user
	@forum_post = forum_post

	mail(
	to: "#{user.email}",
	subject: "[CollegeDevs] New Post in #{forum_post.forum_thread.subject}"
	)
	end
end