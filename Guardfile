require 'fileutils'
require 'pathname'

APP_ROOT = Pathname.new('game').freeze

def warn_if_env_is_not_set
  return if ENV['DRAGONRUBY_PATH']

  puts 'Please set DRAGONRUBY_PATH environment variable with path to dragonruby executable'
  exit
end

warn_if_env_is_not_set

guard :shell do
  watch(/^[^#]*\.rb/) { |m|
    if run_all?(m)
      run_all
    else
      test_path = m[0].include?('tests/') ? Pathname.new(m[0]) : add_test_directory_to_path(m[0])
      next unless test_path.exist?

      run_dragonruby_tests(test_path)
    end
  }
end

def run_all?(match)
  match.is_a? Array
end

def run_all
  run_dragonruby_tests(APP_ROOT / 'tests/main.rb')
end

def add_test_directory_to_path(path)
  path_from_app_root = Pathname.new(path).relative_path_from(APP_ROOT)
  APP_ROOT / 'tests' / path_from_app_root
end

def run_dragonruby_tests(path)
  envs = 'SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy'
  relative_test_path = Pathname.new(path).relative_path_from(APP_ROOT)
  system "#{envs} #{dragonruby_path} #{APP_ROOT} --test #{relative_test_path}"
end

def dragonruby_path
  Pathname.new(ENV['DRAGONRUBY_PATH']).realpath
end
