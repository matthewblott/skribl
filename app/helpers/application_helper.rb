module ApplicationHelper
  include Pagy::Frontend

  def page_title
    content_for(:title || 'Skribl')
  end

  def native_app?
    ios_app? or android_app?
  end

  def ios_app?
    user_agent = request.user_agent
    user_agent.include?("Hotwire Native iOS")
  end

  def android_app?
    user_agent = request.user_agent
    user_agent.include?("Hotwire Native Android")
  end

end
