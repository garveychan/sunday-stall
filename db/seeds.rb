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