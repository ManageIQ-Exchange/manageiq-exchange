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

ActiveRecord::Schema.define(version: 20180208130939) do

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
    t.string "github_token"
    t.string "provider"
    t.index ["user_id"], name: "index_authentication_tokens_on_user_id"
  end

  create_table "spin_candidates", force: :cascade do |t|
    t.text "full_name"
    t.text "validation_log"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published"
    t.boolean "validated"
    t.datetime "last_validation"
    t.index ["published"], name: "index_spin_candidates_on_published"
    t.index ["user_id"], name: "index_spin_candidates_on_user_id"
  end

  create_table "spins", force: :cascade do |t|
    t.boolean "published", default: false
    t.string "name"
    t.text "full_name", default: ""
    t.text "description", default: ""
    t.string "clone_url"
    t.string "html_url"
    t.string "issues_url"
    t.integer "forks_count", default: 0
    t.integer "stargazers_count", default: 0
    t.integer "watchers_count", default: 0
    t.integer "open_issues_count", default: 0
    t.integer "size", default: 0
    t.string "gh_id"
    t.datetime "gh_created_at"
    t.datetime "gh_pushed_at"
    t.datetime "gh_updated_at"
    t.boolean "gh_archived", default: false
    t.string "default_branch", default: "master"
    t.text "readme"
    t.string "license_key"
    t.string "license_name"
    t.string "license_html_url"
    t.string "version", default: "0.0.0"
    t.jsonb "metadata"
    t.text "metadata_raw"
    t.integer "min_miq_version", default: 0
    t.datetime "first_import"
    t.float "score", default: 0.0
    t.bigint "user_id"
    t.text "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_login"
    t.boolean "visible", default: false
    t.jsonb "releases", default: []
    t.bigint "spin_candidate_id"
    t.integer "downloads_count", default: 0
    t.string "downloads_url", default: ""
    t.index ["published"], name: "index_spins_on_published"
    t.index ["spin_candidate_id"], name: "index_spins_on_spin_candidate_id"
    t.index ["user_id"], name: "index_spins_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "spin_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spin_id"], name: "index_taggings_on_spin_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.boolean "admin", default: false, null: false
    t.boolean "staff", default: false, null: false
    t.integer "karma", default: 0, null: false
    t.string "github_avatar_url"
    t.string "github_html_url"
    t.string "github_id"
    t.string "github_login"
    t.string "github_company"
    t.string "github_type"
    t.string "github_blog"
    t.string "github_location"
    t.string "github_bio"
    t.datetime "github_created_at"
    t.datetime "github_updated_at"
    t.string "email"
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
  add_foreign_key "spin_candidates", "users"
  add_foreign_key "spins", "spin_candidates"
  add_foreign_key "spins", "users"
end
