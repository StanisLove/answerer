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

  def visit_server(user: nil, wait: 2)
    url = "http://#{Capybara.server_host}:#{Capybara.server_port}"

    url += "/dev/log_in/#{user.id}" if user.present?

    p "Visit server on #{url}"
    Launchy.open("http://#{Capybara.server_host}:#{Capybara.server_port}/dev/log_in/#{user.id}?redirect_to='")

    if wait.zero?
      p 'Type any key to continue...'
      $stdin.gets
    else
      sleep wait
    end
  end

  def save_screenshot(name = nil)
    path = name || "screenshot-#{Time.now.utc.iso8601.delete(':-')}.png"
    page.save_screenshot path
    File.join(Capybara.save_path, path)
  end

  def leave_last_screenshots(count)
    path  = File.expand_path('*{html,png}', Capybara.save_path)
    files = Dir.glob(path).sort_by do |file_name|
      File.mtime(File.expand_path(file_name, Capybara.save_path))
    end

    count.zero? ? FileUtils.rm_rf(Dir.glob(path)) : FileUtils.rm_rf(files[0...-count])
  end
end
