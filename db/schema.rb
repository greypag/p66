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

ActiveRecord::Schema.define(version: 20171122072506) do

  create_table "carts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crono_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "job_id", null: false
    t.text "log", limit: 4294967295
    t.datetime "last_performed_at"
    t.boolean "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true
  end

  create_table "languages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "user_id"
    t.string "to_user_id"
    t.integer "is_system_notification", default: 0
    t.string "subject"
    t.text "content", limit: 16777215
    t.string "email"
    t.string "from_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_messages_on_ancestry"
  end

  create_table "payment_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "payment_id"
    t.integer "user_id"
    t.string "first_name"
    t.string "last_name"
    t.string "payment_method"
    t.string "price"
    t.datetime "payment_time"
    t.integer "test_id"
    t.string "test_name"
    t.string "payment_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payout_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "rater_id"
    t.string "payout_status"
    t.string "payout_id"
    t.string "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payout_item_fee"
  end

  create_table "prompts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "language"
    t.string "industry"
    t.integer "level"
    t.string "bmr"
    t.string "image"
    t.text "text"
    t.string "video"
    t.string "audio"
  end

  create_table "qars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "language"
    t.string "industry"
    t.integer "level"
    t.string "prompt"
    t.string "bmr"
    t.string "response"
    t.string "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "language"
    t.string "industry"
    t.integer "level"
    t.string "avatar"
    t.integer "response_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "test_record_id"
    t.integer "order"
    t.string "score"
    t.integer "status", default: 0
    t.string "better_than", default: ""
    t.string "as_good_as", default: ""
    t.string "worse_than", default: ""
    t.string "raters"
    t.integer "prompt_id"
  end

  create_table "test_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "test_id"
    t.string "test_name"
    t.integer "status", default: 0
    t.datetime "start_date"
    t.datetime "purchased_date"
    t.string "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "test_begin_photo"
    t.string "test_end_photo"
    t.integer "photo_verification", default: 0
    t.string "language"
    t.string "industry"
  end

  create_table "tests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.text "description"
    t.string "price"
    t.string "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.string "language"
    t.string "industry"
    t.string "ilr1_prompt1"
    t.string "ilr1_prompt2"
    t.string "ilr1plus_prompt1"
    t.string "ilr1plus_prompt2"
    t.string "ilr2_prompt1"
    t.string "ilr2_prompt2"
    t.string "ilr2plus_prompt1"
    t.string "ilr2plus_prompt2"
    t.string "ilr3_prompt1"
    t.string "ilr3_prompt2"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "f_name"
    t.string "l_name"
    t.string "native_language"
    t.string "email"
    t.string "password"
    t.string "status"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_of_birth"
    t.string "gender"
    t.string "industry"
    t.boolean "is_admin", default: false
    t.string "avatar"
    t.string "parrot_id"
    t.boolean "is_rater", default: false
    t.string "recipient_type"
    t.string "receiver"
    t.integer "weekly_rated"
    t.integer "total_rated"
  end

end
