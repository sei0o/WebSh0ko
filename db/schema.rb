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

ActiveRecord::Schema.define(version: 20140312123606) do

  create_table "books", force: true do |t|
    t.string   "photo"
    t.string   "title",       null: false
    t.date     "publish"
    t.integer  "page"
    t.integer  "shelf_id"
    t.string   "category_id"
    t.integer  "rarity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "writer"
  end

  add_index "books", ["title"], name: "title_UNIQUE", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lends", force: true do |t|
    t.integer  "user_id"
    t.integer  "book_id",    null: false
    t.boolean  "lending",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "limit"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "grant",            default: false, null: false
    t.boolean  "book_create",      default: false, null: false
    t.boolean  "book_read",        default: false, null: false
    t.boolean  "book_update",      default: false, null: false
    t.boolean  "book_delete",      default: false, null: false
    t.boolean  "book_lend",        default: false, null: false
    t.boolean  "book_return",      default: false, null: false
    t.boolean  "user_read",        default: false, null: false
    t.boolean  "secret_user_read", default: false, null: false
    t.boolean  "user_update",      default: false, null: false
    t.boolean  "user_delete",      default: false, null: false
    t.boolean  "user_follow",      default: false, null: false
    t.boolean  "role_create",      default: false, null: false
    t.boolean  "role_read",        default: false, null: false
    t.boolean  "role_update",      default: false, null: false
    t.boolean  "role_delete",      default: false, null: false
  end

  create_table "shelves", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer  "role_id",                          default: 1, null: false
    t.string   "name",                                         null: false
    t.string   "account",                                      null: false
    t.string   "password_digest",                              null: false
    t.text     "bio"
    t.integer  "class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.binary   "icon",            limit: 16777215
    t.string   "icon_type"
    t.string   "cookie_token"
  end

  add_index "users", ["account"], name: "account_UNIQUE", unique: true, using: :btree

end
