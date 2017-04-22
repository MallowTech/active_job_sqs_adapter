require "active_job_sqs_adapter/version"
require 'aws-sdk-core'
require 'multi_json'

# Push the jobs into SQS queue
module ActiveJobSqsAdapter
  class << self
    # Initialize and return the SQS client
    def sqs
      Aws::SQS::Client.new
    end

    # Get existing SQS queue url or create a new one
    def get_queue_url(job)
      sqs.create_queue(queue_name: job.queue_name)[:queue_url]
    end

    # Enqueue the job to SQS queue
    def enqueue(job)
      sqs.send_message(
          queue_url: get_queue_url(job),
          message_body: MultiJson.dump(job.serialize)
      )
    end

    # Enqueue the job to SQS queue with delay timestamp
    def enqueue_at(job, timestamp)
      delay = timestamp.to_i - Time.current.to_i
      sqs.send_message(
          queue_url: get_queue_url(job),
          message_body: MultiJson.dump(job.serialize),
          delay_seconds: delay,
      )
    end
  end

  class JobWrapper
    class << self
      def perform(job_data)
        ActiveJob::Base.execute job_data
      end
    end
  end
end
