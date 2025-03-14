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

ActiveRecord::Schema[8.0].define(version: 2025_03_14_005754) do
  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "paper_id", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paper_id"], name: "index_bookmarks_on_paper_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "citations", force: :cascade do |t|
    t.integer "paper_id", null: false
    t.string "cited_paper_arxiv_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paper_id"], name: "index_citations_on_paper_id"
  end

  create_table "papers", force: :cascade do |t|
    t.string "arxiv_id"
    t.string "title"
    t.text "authors"
    t.text "abstract"
    t.string "url"
    t.date "published_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookmarks", "papers"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "citations", "papers"
end
