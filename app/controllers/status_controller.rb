class StatusController < ApplicationController
  skip_before_action :authenticate, only: [:signed_in, :status]
  before_action :prevent_caching, only: [:status]

  def signed_in
    render json: { signed_in: Current.user.present? }
  end

  def signed_in
    render json: { signed_in: Current.user.present? }
  end
  
  def status
  end

  private

  def prevent_caching
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
