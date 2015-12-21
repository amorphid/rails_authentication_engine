class StaticPagesController < ApplicationController
  def home
    render text: "it works!"
  end
end
