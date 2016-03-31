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

ActiveRecord::Schema.define(version: 20160330192005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "sequence",   default: 0
    t.integer  "status",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "translations", force: :cascade do |t|
    t.integer  "post_id"
    t.string   "locale"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translations", ["post_id"], name: "index_translations_on_post_id", using: :btree

  create_table "weeler_locks", force: :cascade do |t|
    t.string   "name",       limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weeler_locks", ["name"], name: "index_weeler_locks_on_name", unique: true, using: :btree

  create_table "weeler_seo_translations", force: :cascade do |t|
    t.integer  "weeler_seo_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "title"
    t.text     "description"
    t.text     "keywords"
  end

  add_index "weeler_seo_translations", ["locale"], name: "index_weeler_seo_translations_on_locale", using: :btree
  add_index "weeler_seo_translations", ["weeler_seo_id"], name: "index_weeler_seo_translations_on_weeler_seo_id", using: :btree

  create_table "weeler_seos", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "keywords"
    t.string   "section"
    t.integer  "seoable_id"
    t.string   "seoable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weeler_seos", ["section"], name: "index_weeler_seos_on_section", using: :btree
  add_index "weeler_seos", ["seoable_type", "seoable_id"], name: "index_weeler_seos_on_seoable_type_and_seoable_id", using: :btree

  create_table "weeler_translation_stats", force: :cascade do |t|
    t.string   "key"
    t.integer  "usage_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weeler_translation_stats", ["key"], name: "index_weeler_translation_stats_on_key", using: :btree

  create_table "weeler_translations", force: :cascade do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
    t.text     "interpolations"
    t.boolean  "is_proc",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weeler_translations", ["key"], name: "index_weeler_translations_on_key", using: :btree
  add_index "weeler_translations", ["locale"], name: "index_weeler_translations_on_locale", using: :btree

end
