# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

#### This app is using sidekiq to process active job

$ rails new active_job_with_sidekiq

$ rails g scaffold User last_name:string first_name:string email:string

$ rake db:create && rake db:migrate

* add create_random method in users_controller.rb

```ruby
	def create_random

		user = User.new(first_name: Faker::Name.first_name, 
                    last_name: Faker::Name.last_name, 
                    email: Faker::Internet.email)
    user.save!
    sleep 2

    redirect_to root_path
	end
```

* add create random user link in views/users/index.html.erb

```html
	<%= link_to "Create Random User", users_create_random_path() %>
```

* modify config/routes.rb to add create_random path

```ruby
	get 'users/create_random'

```

* add gem 'sidekiq' and gem 'redis' gems to Gemfile

* add config/initializers/sidekiq.rb

```ruby
	Sidekiq.configure_server do |config|
		config.redis = { url: 'redis://localhost:6379/0'}
	end

	Sidekiq.configure_client do |config|
		config.redis = { url: 'redis://localhost:6379/0'}
	end
```

* modify config/routes.rb to add sidekiq's web interface

```ruby
	require 'sidekiq/web'
	mount Sidekiq::Web => '/sidekiq'
	.
	.
	~
```

* modify config/application.rb add config.active_job.queue_adapter to use sidekiq

```ruby
	config.active_job.queue_adapter = :sidekiq
	# for development if you don't want to set up redis
	#config.active_job.queue_adapter = Rails.env.production? ? :sidekiq : :async

```

* Add Active Job to generate random user
> rails g job generate_random_user

* modify jobs/generate_random_user_job.rb
```ruby
# rails g job generate_random_user
class GenerateRandomUserJob < ApplicationJob
  queue_as :default

  def perform(*args)
		user = User.new(first_name: Faker::Name.first_name, 
                    last_name: Faker::Name.last_name, 
                    email: Faker::Internet.email)
    user.save!
    sleep 2
  end
end
```

* start redis server on the console
> redis-server

* start up sidekiq from the console
> sidekiq

* start rails server
> rails s

* Make sure to restart redis and sidekiq whenever you make change code that will required to load a gem or library that did not get loaded. In this case, I added Faker gem after both services started, so it will required to restart both services, otherwise Faker will not work inside of ActiveJob.

