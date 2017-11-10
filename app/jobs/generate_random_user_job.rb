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
