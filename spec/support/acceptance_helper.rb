module AcceptanceHelper
  def sign_in(user)
    page.set_rack_session('warden.user.user.key' =>
                          User.serialize_into_session(user).unshift("User"))
  end

  def manual_entry(user)
    visit new_user_session_path
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def search(params)
    visit root_path
    within '.search form' do
      fill_in :query,         with: params[:query]
      select  params[:model], from: :model
      click_on 'Search'
    end
  end
end
