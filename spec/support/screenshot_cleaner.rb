def leave_last_screenshots(count)
  path  = File.expand_path('*{html,png}', Capybara.save_path)
  files = Dir.glob(path).sort_by do |file_name|
    File.mtime(File.expand_path(file_name, Capybara.save_path))
  end

  count.zero? ? FileUtils.rm_rf(Dir.glob(path)) : FileUtils.rm_rf(files[0...-count])
end
