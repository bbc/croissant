require 'thin'
Thin::Runner.new(["--threaded", "-R", "config.ru", "start", "-p", "8080", "-d"]).run!
