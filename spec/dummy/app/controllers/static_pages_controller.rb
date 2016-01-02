class StaticPagesController < ApplicationController
  before_action -> { authenticate! }, only: [:pagey_mc_page, :rooty_mc_root]

  def pagey_mc_page
  end

  def rooty_mc_root
  end
end
