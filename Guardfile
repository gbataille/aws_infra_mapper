# frozen_string_literal:true

group :stop_if_test_fail, halt_on_fail: true do
  guard :rspec, cmd: 'rspec' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^spec/(.+)_factories\.rb$})         { 'spec' }
    watch(%r{^lib/(.+)\.rb$})                   { |m| "spec/#{m[1]}_spec.rb" }

    watch(%r{^spec/utils/.*\.rb$})              { 'spec' }
  end

  guard :rubocop, all_on_start: false, cli: ['--format', 'clang', '-c', '.rubocop.yml'] do
    watch(%r{^.*\.rb$})
  end
end
