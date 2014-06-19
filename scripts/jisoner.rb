require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require
require 'jison'

begin
  # `grammar` is a string consisting of a Jison grammar
  grammar = File.read('./wkt.jison')
  javascript_text = Jison.parse(grammar)
  puts javascript_text

  # do something with javascript_text
rescue Jison::ExecutionError => error
  $stderr.puts "jison command terminated with exit code #{error.exit_code}"
  $stderr.puts "#{error.message}\n  #{error.backtrace.join("\n  ")}"
rescue Errno::ENOENT => error
  $stderr.puts "#{error.message}\n  #{error.backtrace.join("\n  ")}"
  cmd = error.message[/\b\w+$/, 0]
  $stdout.puts "Please be sure #{cmd} is installed and on your $PATH"
end
