require "test/unit"
require "timeout"
require File.dirname(__FILE__) + "/../lib/thread_pool"

describe ThreadPool do
  THREADS = 10
  
  before :each do
    @pool = ThreadPool.new(THREADS)
  end
  
  after :each do
    @pool.close
  end
    
  it 'test_pool_size' do
    @pool.size.should == THREADS 
  end
  
  it 'test_waiting' do
    n = 50
    n.times {
      @pool.execute { sleep 10 }
    }
    sleep 0.01
    @pool.waiting.should == (n - THREADS)
  end
  
  class A
    def initialize(i)
      @i = i
    end
    attr_reader :i
  end
  
  it 'test_context' do
    foo = []
    bar = (0...5).to_a
    while c = bar.shift
      @pool.execute { foo << c }
    end
    @pool.join
    foo.should == [nil] * 5
    
    foo = []
    bar = (0...5).to_a
    while c = bar.shift
      @pool.execute(c) {|n| foo << n }
    end
    @pool.join
    foo.should == (0...5).to_a
  end
  
  it 'test_queue_limit' do
    n = 50
    foo = 0
    @pool.queue_limit = 1
    begin
      Timeout::timeout(0.2) do
        n.times {
          @pool.execute {  sleep 1 }
          foo += 1
        }
      end 
    rescue Timeout::Error
      (@pool.queue_limit + @pool.size).should == foo
    else
      fail
    end
  end
  
  it 'test_execution' do
    Timeout::timeout(1) do
      n = 50
      foo = []
      n.times {
        @pool.execute { foo << "hi" }
      }
      @pool.join
      foo.length.should == n
    end
  end
  
  it 'test_synchronous_execute' do
    Timeout::timeout(1) do
      foo = false
      @pool.execute { sleep 0.01; foo = true }
      foo.should be_false
    
      foo = false
      @pool.synchronous_execute { sleep 0.01; foo = true }
      foo.should be_true
    end
  end
end