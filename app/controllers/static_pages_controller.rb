class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :authorize_user!
end
