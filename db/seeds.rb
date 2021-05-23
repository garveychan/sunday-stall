#Clear Databases

Stall.all.each { |stall| stall.image.purge }
%w[users stalls product_categories].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE;")
end

Dir.glob(Rails.root.join('storage', '**', '*').to_s).sort_by(&:length).reverse.each do |x|
  if File.directory?(x) && Dir.empty?(x)
    Dir.rmdir(x)
  end
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

# Devise test user
User.create! do |u|
  u.email = 'admin@test.com'
  u.password = 'password'
  u.role = 'admin'
end
User.create! do |u|
  u.email = 'user@test.com'
  u.password = 'password'
  u.role = 'user'
end