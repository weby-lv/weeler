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

ActiveRecord::Schema.define(version: 20140123083707) do

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true

  create_table "weeler_seo_translations", force: true do |t|
    t.integer  "weeler_seo_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
    t.text     "keywords"
  end

  add_index "weeler_seo_translations", ["locale"], name: "index_weeler_seo_translations_on_locale"
  add_index "weeler_seo_translations", ["weeler_seo_id"], name: "index_weeler_seo_translations_on_weeler_seo_id"

  create_table "weeler_seos", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "keywords"
    t.string   "section"
    t.integer  "seoable_id"
    t.string   "seoable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weeler_seos", ["section"], name: "index_weeler_seos_on_section"
  add_index "weeler_seos", ["seoable_id", "seoable_type"], name: "index_weeler_seos_on_seoable_id_and_seoable_type"

  create_table "weeler_translations", force: true do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
    t.text     "interpolations"
    t.boolean  "is_proc",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weeler_translations", ["key"], name: "index_weeler_translations_on_key"
  add_index "weeler_translations", ["locale"], name: "index_weeler_translations_on_locale"

end
