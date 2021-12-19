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

ActiveRecord::Schema.define(version: 2016_03_30_192005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "sequence", default: 0
    t.integer "status", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "translations", id: :serial, force: :cascade do |t|
    t.integer "post_id"
    t.string "locale"
    t.string "title"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["post_id"], name: "index_translations_on_post_id"
  end

  create_table "weeler_locks", id: :serial, force: :cascade do |t|
    t.string "name", limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_weeler_locks_on_name", unique: true
  end

  create_table "weeler_seo_translations", force: :cascade do |t|
    t.integer "weeler_seo_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.text "description"
    t.text "keywords"
    t.index ["locale"], name: "index_weeler_seo_translations_on_locale"
    t.index ["weeler_seo_id"], name: "index_weeler_seo_translations_on_weeler_seo_id"
  end

  create_table "weeler_seos", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "keywords"
    t.string "section"
    t.string "seoable_type"
    t.integer "seoable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["section"], name: "index_weeler_seos_on_section"
    t.index ["seoable_type", "seoable_id"], name: "index_weeler_seos_on_seoable"
  end

  create_table "weeler_translation_stats", id: :serial, force: :cascade do |t|
    t.string "key"
    t.integer "usage_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["key"], name: "index_weeler_translation_stats_on_key"
  end

  create_table "weeler_translations", id: :serial, force: :cascade do |t|
    t.string "locale"
    t.string "key"
    t.text "value"
    t.text "interpolations"
    t.boolean "is_proc", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["key"], name: "index_weeler_translations_on_key"
    t.index ["locale"], name: "index_weeler_translations_on_locale"
  end

end
