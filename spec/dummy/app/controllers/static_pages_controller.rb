class StaticPagesController < ApplicationController
  before_action -> { authenticate! }, only: :home

  def home
  end
end
