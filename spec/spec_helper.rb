require File.expand_path(File.dirname(__FILE__) + "/../lib/thread_pool")
require 'spec'

ThreadPool.logger = Logger.new(STDOUT)