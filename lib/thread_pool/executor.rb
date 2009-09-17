class ThreadPool
  class Executor
    attr_reader :active

    def initialize(queue, mutex)
      @thread = Thread.new do
        loop do
          mutex.synchronize { @tuple = queue.shift }
          if @tuple
            ThreadPool.logger.debug "Executor: processing #{@tuple.hash}"
            args, block = @tuple
            @active = true
            begin
              block.call(*args)
            rescue Exception => e
              error e.message
              error e.backtrace.join("\n")
            end
            block.complete = true
            ThreadPool.logger.debug "Executor: complete   #{@tuple.hash}"
          else
            @active = false
            sleep 0.01
          end
        end
      end
    end

    def close
      @thread.exit
    end
  end
end
