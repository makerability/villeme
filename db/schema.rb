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

ActiveRecord::Schema.define(version: 20160320183859) do

  create_table "agenda_items", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agendas", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "average_caches", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type", limit: 255
    t.float    "avg",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "badges_sashes", force: :cascade do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", default: false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], name: "index_badges_sashes_on_badge_id_and_sash_id"
  add_index "badges_sashes", ["badge_id"], name: "index_badges_sashes_on_badge_id"
  add_index "badges_sashes", ["sash_id"], name: "index_badges_sashes_on_sash_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",        limit: 255
  end

  create_table "categories_items", id: false, force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_places", id: false, force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id",             null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        limit: 255
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id"
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale"

  create_table "cities", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address",      limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.string   "label",        limit: 255
    t.integer  "goal",                     default: 250
    t.string   "country_name", limit: 255
    t.string   "country_code", limit: 255
    t.string   "state_name",   limit: 255
    t.string   "state_code",   limit: 255
    t.string   "slug",         limit: 255
    t.boolean  "launch",                   default: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.string   "code",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",       limit: 255
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title",       limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["user_id"], name: "index_feedbacks_on_user_id"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status",      limit: 255
    t.boolean  "confirmed",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "accepted_at"
  end

  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id"

  create_table "invites", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "email",             limit: 255
    t.string   "name",              limit: 255
    t.integer  "city"
    t.integer  "persona"
    t.string   "persona_sugest",    limit: 255
    t.string   "city_sugest",       limit: 255
    t.string   "key",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale",            limit: 255, default: "en"
    t.string   "address",           limit: 255
    t.float    "latitude",          limit: 255
    t.float    "longitude",         limit: 255
    t.string   "route",             limit: 255
    t.string   "neighborhood_name", limit: 255
    t.string   "city_name",         limit: 255
    t.string   "state_name",        limit: 255
    t.string   "state_code",        limit: 255
    t.string   "country_name",      limit: 255
    t.string   "country_code",      limit: 255
    t.string   "postal_code",       limit: 255
    t.string   "street_number",     limit: 255
    t.string   "full_address",      limit: 255
    t.string   "formatted_address", limit: 255
    t.boolean  "invited",                       default: false
  end

  add_index "invites", ["user_id"], name: "index_invites_on_user_id"

  create_table "invites_personas", id: false, force: :cascade do |t|
    t.integer "invite_id"
    t.integer "persona_id"
  end

  add_index "invites_personas", ["invite_id"], name: "index_invites_personas_on_invite_id"
  add_index "invites_personas", ["persona_id"], name: "index_invites_personas_on_persona_id"

  create_table "items", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.text     "description"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "price_id"
    t.string   "address",            limit: 255
    t.date     "date_start"
    t.time     "hour_start_first"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.date     "date_finish"
    t.time     "hour_finish_first"
    t.string   "number",             limit: 255
    t.decimal  "cost",                           precision: 8, scale: 2
    t.time     "hour_start_second"
    t.time     "hour_start_third"
    t.time     "hour_start_fourth"
    t.time     "hour_start_fifth"
    t.time     "hour_start_sixth"
    t.time     "hour_finish_second"
    t.time     "hour_finish_third"
    t.time     "hour_finish_fourth"
    t.time     "hour_finish_fifth"
    t.time     "hour_finish_sixth"
    t.text     "cost_details"
    t.integer  "moderate"
    t.string   "slug",               limit: 255
    t.integer  "persona_id"
    t.string   "link",               limit: 255
    t.string   "email",              limit: 255
    t.string   "phone",              limit: 255
    t.integer  "subcategory_id"
    t.string   "full_address",       limit: 255
    t.string   "country_name",       limit: 255
    t.string   "country_code",       limit: 255
    t.string   "postal_code",        limit: 255
    t.string   "state_name",         limit: 255
    t.string   "state_code",         limit: 255
    t.string   "formatted_address",  limit: 255
    t.string   "city_name",          limit: 255
    t.string   "neighborhood_name",  limit: 255
    t.string   "street_number",      limit: 255
    t.string   "route",              limit: 255
    t.boolean  "allday",                                                 default: false
    t.integer  "agendas_count",                                          default: 0
    t.string   "type",               limit: 255
    t.boolean  "all_year",                                               default: false
  end

  add_index "items", ["persona_id"], name: "index_items_on_persona_id"
  add_index "items", ["place_id"], name: "index_items_on_place_id"
  add_index "items", ["price_id"], name: "index_items_on_price_id"
  add_index "items", ["slug"], name: "index_items_on_slug"
  add_index "items", ["subcategory_id"], name: "index_items_on_subcategory_id"
  add_index "items", ["user_id"], name: "index_items_on_user_id"

  create_table "items_personas", id: false, force: :cascade do |t|
    t.integer "item_id"
    t.integer "persona_id"
  end

  add_index "items_personas", ["item_id"], name: "index_items_personas_on_item_id"
  add_index "items_personas", ["persona_id"], name: "index_items_personas_on_persona_id"

  create_table "items_subcategories", id: false, force: :cascade do |t|
    t.integer "item_id"
    t.integer "subcategory_id"
  end

  add_index "items_subcategories", ["item_id"], name: "index_items_subcategories_on_item_id"
  add_index "items_subcategories", ["subcategory_id"], name: "index_items_subcategories_on_subcategory_id"

  create_table "items_weeks", id: false, force: :cascade do |t|
    t.integer "item_id"
    t.integer "week_id"
  end

  add_index "items_weeks", ["item_id", "week_id"], name: "index_items_weeks_on_item_id_and_week_id", unique: true
  add_index "items_weeks", ["week_id"], name: "index_items_weeks_on_week_id"

  create_table "levels", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "slug",              limit: 255
    t.text     "description"
    t.integer  "nivel"
    t.string   "url",               limit: 255
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name",    limit: 255
    t.string   "icon_content_type", limit: 255
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "merit_actions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "action_method", limit: 255
    t.integer  "action_value"
    t.boolean  "had_errors",                default: false
    t.string   "target_model",  limit: 255
    t.integer  "target_id"
    t.boolean  "processed",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merit_activity_logs", force: :cascade do |t|
    t.integer  "action_id"
    t.string   "related_change_type", limit: 255
    t.integer  "related_change_id"
    t.string   "description",         limit: 255
    t.datetime "created_at"
  end

  create_table "merit_score_points", force: :cascade do |t|
    t.integer  "score_id"
    t.integer  "num_points",             default: 0
    t.string   "log",        limit: 255
    t.datetime "created_at"
  end

  create_table "merit_scores", force: :cascade do |t|
    t.integer "sash_id"
    t.string  "category", limit: 255, default: "default"
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address",      limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.string   "slug",         limit: 255
    t.string   "state_name",   limit: 255
    t.string   "state_code",   limit: 255
    t.string   "country_name", limit: 255
    t.string   "country_code", limit: 255
    t.string   "city_name",    limit: 255
  end

  add_index "neighborhoods", ["slug"], name: "index_neighborhoods_on_slug", unique: true

  create_table "notifies", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "bell_view"
    t.datetime "newsfeed_view"
    t.datetime "persona_view"
    t.datetime "neighborhood_view"
    t.datetime "agenda_view"
    t.datetime "category_view"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifies", ["user_id"], name: "index_notifies_on_user_id"

  create_table "overall_averages", force: :cascade do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type", limit: 255
    t.float    "overall_avg",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "persona_translations", force: :cascade do |t|
    t.integer  "persona_id",             null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
  end

  add_index "persona_translations", ["locale"], name: "index_persona_translations_on_locale"
  add_index "persona_translations", ["persona_id"], name: "index_persona_translations_on_persona_id"

  create_table "personas", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personas_users", id: false, force: :cascade do |t|
    t.integer "persona_id"
    t.integer "user_id"
  end

  add_index "personas_users", ["persona_id"], name: "index_personas_users_on_persona_id"
  add_index "personas_users", ["user_id"], name: "index_personas_users_on_user_id"

  create_table "places", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.text     "description"
    t.integer  "neighborhood_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "full_address",       limit: 255
    t.string   "country_name",       limit: 255
    t.string   "country_code",       limit: 255
    t.string   "postal_code",        limit: 255
    t.string   "state_name",         limit: 255
    t.string   "state_code",         limit: 255
    t.string   "formatted_address",  limit: 255
    t.string   "neighborhood_name",  limit: 255
    t.string   "city_name",          limit: 255
    t.string   "street_number",      limit: 255
    t.string   "route",              limit: 255
    t.string   "address",            limit: 255
    t.string   "cover_file_name",    limit: 255
    t.string   "cover_content_type", limit: 255
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.integer  "user_id"
    t.boolean  "verified",                       default: false
    t.string   "phone",              limit: 255
    t.string   "site",               limit: 255
    t.string   "slug",               limit: 255
  end

  add_index "places", ["neighborhood_id"], name: "index_places_on_neighborhood_id"
  add_index "places", ["slug"], name: "index_places_on_slug", unique: true
  add_index "places", ["user_id"], name: "index_places_on_user_id"

  create_table "prices", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type", limit: 255
    t.float    "stars",                     null: false
    t.string   "dimension",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], name: "index_rates_on_rater_id"

  create_table "rating_caches", force: :cascade do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type", limit: 255
    t.float    "avg",                        null: false
    t.integer  "qty",                        null: false
    t.string   "dimension",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_caches", ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type"

  create_table "sashes", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "states", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.string   "country_name", limit: 255
    t.string   "country_code", limit: 255
    t.string   "code",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",         limit: 255
  end

  create_table "subcategories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tips", force: :cascade do |t|
    t.text     "description"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "tips", ["item_id"], name: "index_tips_on_item_id"
  add_index "tips", ["user_id"], name: "index_tips_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.string   "username",               limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.integer  "sash_id"
    t.integer  "level_id",                           default: 1
    t.boolean  "admin",                              default: false
    t.integer  "persona_id"
    t.boolean  "account_complete",                   default: false
    t.boolean  "invited",                            default: false
    t.string   "token",                  limit: 255
    t.string   "facebook_avatar",        limit: 255
    t.string   "slug",                   limit: 255
    t.string   "token_expires_at",       limit: 255
    t.string   "locale",                 limit: 255
    t.string   "postal_code",            limit: 255
    t.string   "neighborhood_name",      limit: 255
    t.string   "city_name",              limit: 255
    t.string   "state_name",             limit: 255
    t.string   "state_code",             limit: 255
    t.string   "country_name",           limit: 255
    t.string   "country_code",           limit: 255
    t.string   "street_number",          limit: 255
    t.string   "full_address",           limit: 255
    t.string   "route",                  limit: 255
    t.string   "address",                limit: 255
    t.string   "formatted_address",      limit: 255
    t.string   "ip",                     limit: 255
    t.boolean  "guest",                              default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["persona_id"], name: "index_users_on_persona_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true

  create_table "week_translations", force: :cascade do |t|
    t.integer  "week_id",                null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
  end

  add_index "week_translations", ["locale"], name: "index_week_translations_on_locale"
  add_index "week_translations", ["week_id"], name: "index_week_translations_on_week_id"

  create_table "weeks", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "slug",         limit: 255
    t.integer  "binary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organizer_id"
  end

end
