(4..10).each do |i|
  appraise "rspec-3.#{i}" do
    gem "rspec", "~> 3.#{i}.0"
  end
end

rake_versions = %w[
  10.0 10.1 10.2 10.3 10.4 10.5
  11.0 11.1 11.2 11.3
  12.0 12.1 12.2 12.3
  13.0
]
rake_versions.each do |version|
  next if version >= '13' && RUBY_VERSION < '2.3' # Rake 13 supports Ruby 2.3+.

  appraise "rake-#{version}" do
    gem 'rake', "~> #{version}.0"
  end
end
