guard :rspec, cmd: "rspec" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/(.+)/(.+)_factories\.rb$})   { 'spec' }
  watch(%r{^lib/(.+)\.rb$})                   { |m| "spec/#{m[1]}_spec.rb" }

  watch(%r{^spec/utils/.*\.rb$})              { 'spec' }
end

guard :rubocop, all_on_start: false, cli: ['--format', 'clang'] do
  watch(%r{^.*\.rb})
end
