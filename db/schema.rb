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

ActiveRecord::Schema[8.1].define(version: 2026_03_25_120001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assessments", force: :cascade do |t|
    t.text "answer_key_html"
    t.string "assessment_type", null: false
    t.text "content_html", null: false
    t.bigint "content_module_id", null: false
    t.datetime "created_at", null: false
    t.text "rubric_html"
    t.datetime "updated_at", null: false
    t.index ["content_module_id", "assessment_type"], name: "index_assessments_on_content_module_id_and_assessment_type", unique: true
    t.index ["content_module_id"], name: "index_assessments_on_content_module_id"
  end

  create_table "content_modules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "grade_id", null: false
    t.integer "number", null: false
    t.text "overview_html"
    t.integer "position", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["grade_id", "number"], name: "index_content_modules_on_grade_id_and_number", unique: true
    t.index ["grade_id", "position"], name: "index_content_modules_on_grade_id_and_position"
    t.index ["grade_id"], name: "index_content_modules_on_grade_id"
  end

  create_table "exit_tickets", force: :cascade do |t|
    t.text "content_html", null: false
    t.datetime "created_at", null: false
    t.bigint "lesson_id", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_exit_tickets_on_lesson_id", unique: true
  end

  create_table "expressions", force: :cascade do |t|
    t.text "aspose_html"
    t.jsonb "conversion_notes", default: {}
    t.string "conversion_status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.string "image_content_type"
    t.text "image_data"
    t.text "mathml"
    t.text "omml"
    t.integer "position", null: false
    t.bigint "source_id", null: false
    t.string "source_type", null: false
    t.string "text_representation"
    t.datetime "updated_at", null: false
    t.index ["conversion_status"], name: "index_expressions_on_conversion_status"
    t.index ["source_type", "source_id", "position"], name: "idx_expressions_source_position", unique: true
    t.index ["source_type", "source_id"], name: "index_expressions_on_source"
  end

  create_table "grades", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "number", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_grades_on_number", unique: true
  end

  create_table "homeworks", force: :cascade do |t|
    t.text "content_html", null: false
    t.datetime "created_at", null: false
    t.bigint "lesson_id", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_homeworks_on_lesson_id", unique: true
  end

  create_table "lesson_plans", force: :cascade do |t|
    t.text "content_html", null: false
    t.datetime "created_at", null: false
    t.bigint "lesson_id", null: false
    t.integer "suggested_duration_minutes"
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lesson_plans_on_lesson_id", unique: true
  end

  create_table "lessons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "head_html"
    t.integer "number", null: false
    t.text "objective"
    t.integer "position", null: false
    t.string "source_file"
    t.text "tail_html"
    t.bigint "topic_id", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id", "number"], name: "index_lessons_on_topic_id_and_number", unique: true
    t.index ["topic_id", "position"], name: "index_lessons_on_topic_id_and_position"
    t.index ["topic_id"], name: "index_lessons_on_topic_id"
  end

  create_table "problem_sets", force: :cascade do |t|
    t.text "content_html", null: false
    t.datetime "created_at", null: false
    t.bigint "lesson_id", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_problem_sets_on_lesson_id", unique: true
  end

  create_table "problems", force: :cascade do |t|
    t.text "answer"
    t.string "answer_format"
    t.text "content_html", null: false
    t.datetime "created_at", null: false
    t.integer "position", null: false
    t.bigint "source_id", null: false
    t.string "source_type", null: false
    t.datetime "updated_at", null: false
    t.index ["source_type", "source_id", "position"], name: "index_problems_on_source_type_and_source_id_and_position", unique: true
    t.index ["source_type", "source_id"], name: "index_problems_on_source"
  end

  create_table "standard_taggings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "standard_id", null: false
    t.bigint "taggable_id", null: false
    t.string "taggable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["standard_id", "taggable_type", "taggable_id"], name: "idx_standard_taggings_uniqueness", unique: true
    t.index ["standard_id"], name: "index_standard_taggings_on_standard_id"
    t.index ["taggable_type", "taggable_id"], name: "index_standard_taggings_on_taggable"
  end

  create_table "standards", force: :cascade do |t|
    t.string "cluster"
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "domain", null: false
    t.integer "grade_level", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_standards_on_code", unique: true
    t.index ["grade_level"], name: "index_standards_on_grade_level"
  end

  create_table "supplemental_resources", force: :cascade do |t|
    t.text "content_html"
    t.datetime "created_at", null: false
    t.integer "position"
    t.string "resource_type", null: false
    t.bigint "resourceable_id", null: false
    t.string "resourceable_type", null: false
    t.string "source", null: false
    t.string "source_page_url"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["resource_type"], name: "index_supplemental_resources_on_resource_type"
    t.index ["resourceable_type", "resourceable_id", "resource_type"], name: "idx_supplemental_resources_lookup"
    t.index ["resourceable_type", "resourceable_id"], name: "index_supplemental_resources_on_resourceable"
    t.index ["source"], name: "index_supplemental_resources_on_source"
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "content_module_id", null: false
    t.datetime "created_at", null: false
    t.string "letter", null: false
    t.text "overview_html"
    t.integer "position", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["content_module_id", "letter"], name: "index_topics_on_content_module_id_and_letter", unique: true
    t.index ["content_module_id", "position"], name: "index_topics_on_content_module_id_and_position"
    t.index ["content_module_id"], name: "index_topics_on_content_module_id"
  end

  add_foreign_key "assessments", "content_modules"
  add_foreign_key "content_modules", "grades"
  add_foreign_key "exit_tickets", "lessons"
  add_foreign_key "homeworks", "lessons"
  add_foreign_key "lesson_plans", "lessons"
  add_foreign_key "lessons", "topics"
  add_foreign_key "problem_sets", "lessons"
  add_foreign_key "standard_taggings", "standards"
  add_foreign_key "topics", "content_modules"
end
