# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :test, :all_after_pass => false do
  watch(%r{^lib/(.+)\.rb$})     
  watch(%r{^test/.+_test\.rb$})
  watch('test/test_helper.rb')
end
