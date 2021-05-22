ProductCategory.delete_all
User.delete_all
ActiveRecord::Base.connection.reset_pk_sequence!('product_categories')
ActiveRecord::Base.connection.reset_pk_sequence!('users')

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