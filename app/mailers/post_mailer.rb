class PostMailer < ApplicationMailer
  default from: 'from@example.com'
  layout 'mailer'

  def post_mail(post)
    @post = post

	mail to: "kazuki_saito@diveintocode.jp", subject: "投稿できたよ"
  end
end
