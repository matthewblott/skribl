module ApplicationHelper
  include Pagy::Frontend

  Pagy::DEFAULT[:limit] = 8

end
