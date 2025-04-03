module ApplicationHelper
  include Pagy::Frontend

  Pagy::DEFAULT[:limit] = 8

  def page_title
    content_for(:title || 'Scribble')
  end

end
