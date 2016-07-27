shared_context "feature", type: :feature do
  if Nenv.scr_shot?
    before(:all) { leave_last_screenshots(5) }

    after(:each) do |example|
      next unless example.exception
      meta = example.metadata
      next unless meta[:js] == true
      filename        = File.basename(meta[:file_path])
      line_number     = meta[:line_number]
      screenshot_name = "screenshot-#{filename}-#{line_number}.png"
      path            = save_screenshot(screenshot_name)
      `display #{path}` if Nenv.scr_shot.to_i == 2
      puts "Failure screenshot: #{path}"
    end
  end
end
