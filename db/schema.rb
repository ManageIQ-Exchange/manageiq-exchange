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

ActiveRecord::Schema.define(version: 20171130091259) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentication_tokens", force: :cascade do |t|
    t.string "body"
    t.bigint "user_id"
    t.datetime "last_used_at"
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_authentication_tokens_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "admin", default: false, null: false
    t.boolean "staff", default: false, null: false
    t.integer "karma", default: 0, null: false
    t.string "github_avatar_url", default: "", null: false
    t.string "github_html_url", null: false
    t.string "github_id", null: false
    t.string "github_login", null: false
    t.string "github_company", default: "", null: false
    t.string "github_type", null: false
    t.string "github_blog", default: "", null: false
    t.string "github_location", default: "", null: false
    t.string "github_bio", default: "", null: false
    t.datetime "github_created_at", null: false
    t.datetime "github_updated_at", null: false
    t.string "email", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_id"], name: "index_users_on_github_id", unique: true
  end

  add_foreign_key "authentication_tokens", "users"
end
