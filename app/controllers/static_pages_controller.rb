class StaticPagesController < ApplicationController
  skip_before_action :authenticate
end
