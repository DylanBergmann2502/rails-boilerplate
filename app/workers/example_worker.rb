# app/workers/example_worker.rb
class ExampleWorker < ApplicationWorker
    sidekiq_options queue: :default, retry: 5
  
    def perform(name, count = 1)
      logger.info "Doing hard work for #{name}, #{count} times"
      sleep 1 # Simulate work
    end
end