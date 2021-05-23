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
%w[users stalls product_categories keywords keywords_stalls].each do |table|
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

# Stall Seeding - Title, Subtitle, Description, Keywords
stall_details = [
  ["Bob Ross' Studio", "Powerful Paintings", "The finest custom paintings that the markets have to offer.", "Art Paint Beautiful Collections Emotion Moving"],
  ["Mary's Florist", "Flowers and Bouquets", "Colourful and bright - flowers for every occasion.", "Art Flowers Bouquets Roses Daisies Flora Gift Special"],
  ["Five Pillars Fine Drinks", "Gins, Spritz, Bubbles", "Share a bottle of bubbles with incredibly nuanced flavours today!", "Beer Gin Prosecco Booze Lit Tipsy Fun Alcohol"],
  ["Levain Artisans", "Fresh Bread", "Straight from the oven, these famous breads will leave you wanting more.", "Food Sourdough Brioche Baguette Bread Baking Yeast"],
  ["Community Cuisine", "Homestyle Meals", "Delicious meals cooked in a home kitchen with love.", "Food Warm Delicious Love Friends Community"]
]

stall_details.each_with_index do |array, index|
  details = {
    active: true,
    description: array[2],
    subtitle: array[1],
    title: array[0],
    user_id: rand(1..10)
  }

  stall = Stall.create!(details)

  array[3].split.each { |keyword| k = Keyword.find_or_create_by({term: keyword.downcase}); stall.keywords << k }

  stall.image.attach(io: File.open(Rails.root / 'db' / 'seed-images' / 'stalls' / "#{index + 1}.jpg"), filename:"#{index + 1}.jpg")
end