class PagesController < ApplicationController
  # Designates pages that a non-logged in user can access
  skip_before_action :authenticate_user!, only: :home

  def home
  end
end
