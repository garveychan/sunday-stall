# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_21_095045) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "unit_num"
    t.integer "street_num"
    t.string "street_name", limit: 50
    t.string "city_name", limit: 50
    t.string "state_name", limit: 50
    t.integer "post_code"
    t.string "country_name", limit: 50
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "term", limit: 50
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name", limit: 50
  end

  create_table "products", force: :cascade do |t|
    t.string "name", limit: 5, null: false
    t.text "description", null: false
    t.integer "price", null: false
    t.integer "stock_level", null: false
    t.boolean "active", null: false
    t.bigint "stall_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_category_id", null: false
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.index ["stall_id"], name: "index_products_on_stall_id"
  end

  create_table "search_terms", id: false, force: :cascade do |t|
    t.bigint "stall_id", null: false
    t.bigint "keywords_id", null: false
    t.index ["keywords_id"], name: "index_search_terms_on_keywords_id"
    t.index ["stall_id"], name: "index_search_terms_on_stall_id"
  end

  create_table "stalls", force: :cascade do |t|
    t.string "title", limit: 50
    t.string "subtitle", limit: 100
    t.text "description"
    t.boolean "active"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_stalls_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", limit: 50
    t.string "last_name", limit: 50
    t.date "date_of_birth"
    t.string "email_address", limit: 100, null: false
    t.string "phone_number", limit: 12
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "products", "product_categories"
  add_foreign_key "products", "stalls"
  add_foreign_key "search_terms", "keywords", column: "keywords_id"
  add_foreign_key "search_terms", "stalls"
  add_foreign_key "stalls", "users"
end
