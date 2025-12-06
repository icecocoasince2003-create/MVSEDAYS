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
ActiveRecord::Schema[7.2].define(version: 2025_12_02_000006) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "journals", force: :cascade do |t|
    t.text "tweet"                      # 削除推奨 (body と重複)
    t.date "visit_date"
    t.date "post_date"
    t.text "body"
    t.integer "user_id"
    t.integer "overall"
    t.integer "rate"
    t.integer "museum_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    # tag カラムは削除済み (20251202000006)
    t.index ["museum_id"], name: "index_journals_on_museum_id"
    t.index ["user_id"], name: "index_journals_on_user_id"  # 追加
    t.index ["visit_date"], name: "index_journals_on_visit_date"  # 追加
    t.index ["user_id", "visit_date"], name: "index_journals_on_user_id_and_visit_date"  # 追加
    t.index ["museum_id", "visit_date"], name: "index_journals_on_museum_id_and_visit_date"  # 追加
  end

  create_table "museums", force: :cascade do |t|
    t.string "name"
    t.string "prefecture"
    t.string "city"
    t.string "registration_type"
    t.string "museum_type"
    t.string "official_website"
    t.text "address"
    t.text "description"
    t.boolean "is_featured"
    t.integer "visit_count", default: 0  # デフォルト値追加
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_museums_on_city"
    t.index ["museum_type"], name: "index_museums_on_museum_type"
    t.index ["name"], name: "index_museums_on_name"
    t.index ["prefecture", "city"], name: "index_museums_on_prefecture_and_city"
    t.index ["prefecture"], name: "index_museums_on_prefecture"
    t.index ["registration_type"], name: "index_museums_on_registration_type"  # 追加
    t.index ["is_featured"], name: "index_museums_on_is_featured"  # 追加
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  # tweet_tag_relations → journal_tag_relations にリネーム
  create_table "journal_tag_relations", force: :cascade do |t|
    t.integer "journal_id", null: false  # tweet_id から変更
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_journal_tag_relations_on_tag_id"
    t.index ["journal_id"], name: "index_journal_tag_relations_on_journal_id"  # 変更
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    
    # 新規追加カラム (20251202000001)
    t.string "username"
    
    # Confirmable (20251202000002)
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    
    # Trackable (20251202000003)
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    
    # Lockable (20251202000003)
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true  # 追加
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true  # 追加
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true  # 追加
  end

  # 外部キー制約
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "journals", "museums"
  add_foreign_key "journals", "users"  # 追加
  add_foreign_key "journal_tag_relations", "journals"  # 修正 (tweets → journals)
  add_foreign_key "journal_tag_relations", "tags"
end

# ActiveRecord::Schema[7.2].define(version: 2025_12_01_141452) do
#   create_table "active_storage_attachments", force: :cascade do |t|
#     t.string "name", null: false
#     t.string "record_type", null: false
#     t.bigint "record_id", null: false
#     t.bigint "blob_id", null: false
#     t.datetime "created_at", null: false
#     t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
#     t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
#   end

#   create_table "active_storage_blobs", force: :cascade do |t|
#     t.string "key", null: false
#     t.string "filename", null: false
#     t.string "content_type"
#     t.text "metadata"
#     t.string "service_name", null: false
#     t.bigint "byte_size", null: false
#     t.string "checksum"
#     t.datetime "created_at", null: false
#     t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
#   end

#   create_table "active_storage_variant_records", force: :cascade do |t|
#     t.bigint "blob_id", null: false
#     t.string "variation_digest", null: false
#     t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
#   end

#   create_table "journals", force: :cascade do |t|
#     t.text "tweet"
#     t.date "visit_date"
#     t.date "post_date"
#     t.text "tag"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#     t.text "body"
#     t.integer "user_id"
#     t.integer "overall"
#     t.integer "rate"
#     t.integer "museum_id"
#     t.index ["museum_id"], name: "index_journals_on_museum_id"
#   end

#   create_table "museums", force: :cascade do |t|
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#     t.string "name"
#     t.string "prefecture"
#     t.string "city"
#     t.string "registration_type"
#     t.string "museum_type"
#     t.string "official_website"
#     t.text "address"
#     t.text "description"
#     t.boolean "is_featured"
#     t.integer "visit_count"
#     t.index ["city"], name: "index_museums_on_city"
#     t.index ["museum_type"], name: "index_museums_on_museum_type"
#     t.index ["name"], name: "index_museums_on_name"
#     t.index ["prefecture", "city"], name: "index_museums_on_prefecture_and_city"
#     t.index ["prefecture"], name: "index_museums_on_prefecture"
#   end

#   create_table "tags", force: :cascade do |t|
#     t.string "name"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#   end

#   create_table "tweet_tag_relations", force: :cascade do |t|
#     t.integer "tweet_id", null: false
#     t.integer "tag_id", null: false
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#     t.index ["tag_id"], name: "index_tweet_tag_relations_on_tag_id"
#     t.index ["tweet_id"], name: "index_tweet_tag_relations_on_tweet_id"
#   end

#   create_table "users", force: :cascade do |t|
#     t.string "email", default: "", null: false
#     t.string "encrypted_password", default: "", null: false
#     t.string "reset_password_token"
#     t.datetime "reset_password_sent_at"
#     t.datetime "remember_created_at"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#     t.boolean "admin"
#     t.index ["email"], name: "index_users_on_email", unique: true
#     t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
#   end

#   add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
#   add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
#   add_foreign_key "journals", "museums"
#   add_foreign_key "tweet_tag_relations", "tags"
#   add_foreign_key "tweet_tag_relations", "tweets"
# end