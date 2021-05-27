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
TABLES = [
  'users',
  'stalls',
  'products',
  'product_categories',
  'keywords',
  'keywords_stalls',
  'favourites',
  'reviews'
]

TABLES.each do |table|
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
    u.first_name = Faker::Name.unique.name.split.first
    u.last_name = Faker::Name.unique.name.split.last
    u.date_of_birth = Faker::Date.between(from: '1950-01-01', to: '2021-01-01').strftime('%Y-%m-%d')
    u.phone_number = Faker::Number.leading_zero_number(digits: 12)
    u.email = "#{role}@test.com"
    u.password = "password"
    u.password_confirmation = 'password'
    u.role = "#{role}"
  end
end

# Mass User Seeding
require 'faker'

number_of_users = 30

number_of_users.times do
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

# Stall Seeding
# Title, Subtitle, Description, Keywords
stall_details = [
  ["Bob Ross' Studio", "Powerful Paintings", "The finest custom paintings that the markets have to offer.", "Art Paint Beautiful Collections Emotion Moving"],
  ["Mary's Florist", "Flowers and Bouquets", "Colourful and bright - flowers for every occasion.", "Art Flowers Bouquets Roses Daisies Flora Gift Special"],
  ["Five Pillars Fine Drinks", "Gins, Spritz, Bubbles", "Share a bottle of bubbles with friends today!", "Beer Gin Prosecco Booze Lit Tipsy Fun Alcohol"],
  ["Levain Artisans", "Fresh Bread", "Straight from the oven, these famous breads will leave you wanting more.", "Food Sourdough Brioche Baguette Bread Baking Yeast"],
  ["Community Cuisine", "Homestyle Meals", "Delicious meals cooked in a home kitchen with love.", "Food Warm Delicious Love Friends Community"],
  ["Gretchen's Gardening", "Lively Plants", "Beautiful plants for bringing extra life into your household.", "Plants Pots Succulents Terrariums Green"],
  ["Vintage Records", "Specialty Vintage Items", "Rare vintage items and antiques for collectors!", "Rare Vintage Record Antique Collectible"],
  ["Ceramix", "Assorted Ceramics", "The hottest ceramics in town - crafted with love and care. Great gifts!", "Ceramic Art Bowl Mug Collectible"] 
]

product_details = [
  [["Blue Ocean", "Soft Hues of Water and Sand.", 3],["Red Lava", "The Gods are angry.",3]],
  [["Roses in a Vase", "These will lighten up any room.", 4], ["Bright Bouquet", "A heartfelt gift for any occassion.", 4]],
  [["Fruity Cocktail", "A surprise flavour every time.", 1], ["Fancy Spirits", "Who knows what we'll send you?", 1]],
  [["Sliced Bread", "Who likes slicing their own bread?", 1], ["Baked Bread", "Crisp and Golden - Eat within the hour.", 1]],
  [["Tofu Laksa", "Spicy and Hot! Will keep you warm on any Winter night.", 1], ["Seared Salmon", "Protein, healthy fats, greens. You can't go wrong!", 1]],
  [["Succulents", "We'll send you a random succulent with a pretty pot from our partners at Ceramix.", 4], ["Terrariums", "Handmade works of art - bring life to your side table.", 4]],
  [["Random Record", "An authentic vinyl record from the last century, it will impress anyone.", 6], ["Vinyl Player", "For the enthusiasts who need proper gear - this is the real deal.", 6]],
  [["White Bowl with Character", "Every single one is handmade and unique - perfect for your next dinner party.", 3], ["Handcrafted Mug", "That cute barista is going to be so impressed.", 3]]
]

# Set stall details based on array data
stall_details.each.with_index do |array, index|
  details = {
    active: true,
    title: array[0],
    subtitle: array[1],
    description: array[2]
  }

  # Assign stall to random seeded user
  user_ids = (1..number_of_users).to_a.sample(stall_details.size)
  details[:user_id] = user_ids[index]

  # Build stall object with details and save
  stall = Stall.new(details)
  stall.save(validate: false)

  # Assign keywords to stall based on array data
  array[3].split.each { |keyword| k = Keyword.find_or_create_by({term: keyword.downcase}); stall.keywords << k }

  # Attach image to stall from folder
  stall.image.attach(io: File.open(Rails.root / 'db' / 'seed-images' / 'stalls' / "#{index + 1}.jpeg"), filename:"#{index + 1}.jpeg")

# Product Seeding (2 for each stall)
# Name, Description, Product Category
  for i in (0..1) do
    details = {
      active: true,
      stall_id: index + 1,
      name: product_details[index][i][0],
      description: product_details[index][i][1],
      stock_level: rand(1..500),
      unit_price: Faker::Number.between(from: 0.0, to: 100.0).round(2),
      product_category_id: product_details[index][i][2]
    }

    # Build product object with details and save
    product = Product.new(details)
    product.save(validate: false)

    # Attach image to stall from folder
    product.image.attach(io: File.open(Rails.root / 'db' / 'seed-images' / 'products' / "#{index + 1}_#{i + 1}.jpg"), filename:"#{index + 1}_#{i + 1}.jpg")
  end
end