module ApplicationHelper
  def page_title
    content_for(:title || 'Skribl')
  end

  def is_signed_in?
    !Current.user.nil? 
  end

  def is_guest_user?
    !Current.user.otp_user?
  end

  def is_native_app?
    is_ios_app? or is_android_app?
  end

  def is_ios_app?
    request.user_agent.to_s.include?("Hotwire Native iOS")
  end

  def is_android_app?
    request.user_agent.to_s.include?("Hotwire Native Android")
  end

end
