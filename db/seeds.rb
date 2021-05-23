# Purge image attachments
Stall.all.each { |stall| stall.image.purge }
Product.all.each { |stall| stall.image.purge }

# Purge empty folders created by Active Storage (local)
Dir.glob(Rails.root.join('storage', '**', '*').to_s).sort_by(&:length).reverse.each do |x|
  if File.directory?(x) && Dir.empty?(x)
    Dir.rmdir(x)
  end
end

# Drop tables, their dependents and restart their sequences
%w[users stalls product_categories].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE;")
end

# Seed Product Categories
product_categories = [
  'Food & Drink',
  'Fresh Produce',
  'Arts & Crafts',
  'Plants & Flowers',
  'Health & Beauty',
  'Others'
]
product_categories.each { |p| ProductCategory.create!(name: p) }

# Authentication/Authorisation Test Users
%w[admin moderator user].each do |role|
  User.create! do |u|
    u.email = "#{role}@test.com"
    u.password = "password"
    u.role = "#{role}"
  end
end

# Mass User Seeding
require 'faker'

100.times do
  User.new do |u|
    u.first_name = Faker::Name.unique.name.split.first
    u.last_name = Faker::Name.unique.name.split.last
    u.date_of_birth = Faker::Date.between(from: '1950-01-01', to: '2021-01-01').strftime('%Y-%m-%d')
    u.phone_number = Faker::Number.leading_zero_number(digits: 12)
    u.email = Faker::Internet.email
    u.password = 'password'
    u.password_confirmation = 'password'
    u.role = 'user'
  end.save
end
