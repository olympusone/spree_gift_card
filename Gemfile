source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

spree_opts = '~> 4.3.2'
gem 'spree', spree_opts
gem 'spree_backend', spree_opts
gem 'rails-controller-testing'

gemspec
