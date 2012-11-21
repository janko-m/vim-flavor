Given 'flavorfile' do |content|
  create_file expand('$tmp').to_flavorfile_path, expand(content)
end

When 'I edit flavorfile as' do |content|
  steps %Q{
    Given flavorfile
    """
    #{content}
    """
  }
end