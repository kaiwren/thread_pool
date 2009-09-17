class ThreadPool
  module Completable
    def complete=(val)
      @complete = val
    end
    
    def complete?
      !!@complete
    end
  end
end