# ActiveJobSqsAdapter

An easy to use adapter for Rails ActiveJob for performing background jobs through [AWS SQS](https://aws.amazon.com/sqs/). 
This can be used to push the jobs to AWS SQS queue and to execute the jobs from the SQS queue.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_job_sqs_adapter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_job_sqs_adapter

## Configuration:
To push the jobs to SQS queue just set the ActiveJob queue adapter as **ActiveJobSqsAdapter** either in `config/application.rb` or in the specific environment config file:   

```ruby
class Application < Rails::Application
  # ...
  config.active_job.queue_adapter = ActiveJobSqsAdapter
end
```

Create a job using rails generator:
```ruby
rails generate job SqsExampleJob
```

The generator will create the job in `/app/jobs/sqs_example_job.rb` as below:

```ruby
class SqsExampleJob < ActiveJob::Base
  # Set the Queue as Default
  queue_as :default
  
  def perform(*args)
    # Perform Job
  end
end
```

##### Queue:
The above job(`SqsExampleJob`) will use `default` queue.

For more about specifying the queue to which the jobs needs to be pushed in the SQS see: [active_job_basics#queues](http://edgeguides.rubyonrails.org/active_job_basics.html#queues)



## Usage
Just run the job as usual and and **ActiveJobSqsAdapter** with handle the rest.

```ruby
SqsExampleJob.perform_later(args)
```

If you wish to perform jobs immediately and not in background just use `perform_now` instead of `perform_later` 
```ruby
SqsExampleJob.perform_now(args)
```

##### Delay:
Set delay for the job to perform:
```ruby
SqsExampleJob.set(wait: 10.minutes).perform_later(args)
```

__Note:__ The maximum delay time can be set for a job is **15 minutes** because of the restriction in AWS SQS.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MallowTech/active_job_sqs_adapter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

You can just:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

