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

ActiveRecord::Schema[7.1].define(version: 4) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "issue_id", null: false
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.boolean "is_internal", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_internal"], name: "index_comments_on_is_internal"
    t.index ["issue_id", "created_at"], name: "index_comments_on_issue_id_and_created_at"
    t.index ["issue_id"], name: "index_comments_on_issue_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "title", limit: 500, null: false
    t.text "description"
    t.string "status", default: "active", null: false
    t.string "priority", default: "medium", null: false
    t.bigint "assigned_to_id"
    t.bigint "reporter_id", null: false
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_issues_on_assigned_to_id"
    t.index ["priority"], name: "index_issues_on_priority"
    t.index ["project_id", "status"], name: "index_issues_on_project_id_and_status"
    t.index ["project_id"], name: "index_issues_on_project_id"
    t.index ["reporter_id"], name: "index_issues_on_reporter_id"
    t.index ["status"], name: "index_issues_on_status"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", limit: 200, null: false
    t.text "description"
    t.string "status", default: "active", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_projects_on_name"
    t.index ["status"], name: "index_projects_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "email", null: false
    t.string "password"
    t.string "avatar_url"
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["is_active"], name: "index_users_on_is_active"
  end

  add_foreign_key "comments", "issues"
  add_foreign_key "comments", "users"
  add_foreign_key "issues", "projects"
  add_foreign_key "issues", "users", column: "assigned_to_id"
  add_foreign_key "issues", "users", column: "reporter_id"
end
