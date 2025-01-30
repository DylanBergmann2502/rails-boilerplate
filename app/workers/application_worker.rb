# app/workers/application_worker.rb
class ApplicationWorker
  include Sidekiq::Worker

  def self.inherited(subclass)
    super
    subclass.sidekiq_options retry: 3, backtrace: true
  end
end