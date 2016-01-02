require 'rails_helper'

shared_examples 'an authenticated user visiting a page for guests' do
  before do
    session[:user_id] = Fabricate(:user).id
    action
  end

  it 'displays flash info to authenticated users' do
    expect(flash[:info]).to eq(t('rails_authentication_engine.flash.authenticated_user_exists'))
  end

  it 'redirects to root path' do
    expect(response).to redirect_to(main_app.root_path)
  end
end
