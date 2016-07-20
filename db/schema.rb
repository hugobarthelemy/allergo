# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160720114901) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allergies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "allergies_ingredients", force: :cascade do |t|
    t.integer  "ingredient_id"
    t.integer  "allergy_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "allergies_ingredients", ["allergy_id"], name: "index_allergies_ingredients_on_allergy_id", using: :btree
  add_index "allergies_ingredients", ["ingredient_id"], name: "index_allergies_ingredients_on_ingredient_id", using: :btree

  create_table "ingredients", force: :cascade do |t|
    t.string   "iso_reference"
    t.string   "fr_name"
    t.string   "en_name"
    t.string   "ja_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "levels", force: :cascade do |t|
    t.integer  "allergy_level"
    t.integer  "user_id"
    t.integer  "allergy_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "levels", ["allergy_id"], name: "index_levels_on_allergy_id", using: :btree
  add_index "levels", ["user_id"], name: "index_levels_on_user_id", using: :btree

  create_table "product_components", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "ingredient_id"
    t.integer  "product_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "product_components", ["ingredient_id"], name: "index_product_components_on_ingredient_id", using: :btree
  add_index "product_components", ["product_id"], name: "index_product_components_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "barcode"
    t.string   "name"
    t.date     "updated_on"
    t.string   "manufacturer"
    t.string   "category"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "product_id"
  end

  add_index "reviews", ["product_id"], name: "index_reviews_on_product_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "scanned_products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "product_id"
  end

  add_index "scanned_products", ["product_id"], name: "index_scanned_products_on_product_id", using: :btree
  add_index "scanned_products", ["user_id"], name: "index_scanned_products_on_user_id", using: :btree

  create_table "tracked_products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "product_id"
  end

  add_index "tracked_products", ["product_id"], name: "index_tracked_products_on_product_id", using: :btree
  add_index "tracked_products", ["user_id"], name: "index_tracked_products_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "email_contact"
    t.string   "provider"
    t.string   "uid"
    t.string   "picture"
    t.string   "token"
    t.datetime "token_expiry"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "allergies_ingredients", "allergies"
  add_foreign_key "allergies_ingredients", "ingredients"
  add_foreign_key "levels", "allergies"
  add_foreign_key "levels", "users"
  add_foreign_key "product_components", "ingredients"
  add_foreign_key "product_components", "products"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "users"
  add_foreign_key "scanned_products", "products"
  add_foreign_key "scanned_products", "users"
  add_foreign_key "tracked_products", "products"
  add_foreign_key "tracked_products", "users"
end
