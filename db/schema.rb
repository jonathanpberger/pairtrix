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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130404001048) do

  create_table "companies", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "companies", ["user_id", "name"], :name => "index_companies_on_user_id_and_name"

  create_table "company_memberships", :force => true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "company_memberships", ["company_id", "user_id"], :name => "index_company_memberships_on_company_id_and_user_id"
  add_index "company_memberships", ["role"], :name => "index_company_memberships_on_role"

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "avatar"
    t.integer  "company_id"
    t.boolean  "do_not_pair", :default => false
  end

  add_index "employees", ["company_id", "last_name", "first_name"], :name => "index_employees_on_company_id_and_last_name_and_first_name"

  create_table "membership_requests", :force => true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "hash_key"
  end

  add_index "membership_requests", ["company_id", "user_id"], :name => "index_membership_requests_on_company_id_and_user_id"
  add_index "membership_requests", ["hash_key"], :name => "index_membership_requests_on_hash_key"
  add_index "membership_requests", ["status"], :name => "index_membership_requests_on_status"

  create_table "pair_memberships", :force => true do |t|
    t.integer  "pair_id"
    t.integer  "team_membership_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "pair_memberships", ["pair_id", "team_membership_id"], :name => "index_pair_memberships_on_pair_id_and_team_membership_id"

  create_table "pairing_days", :force => true do |t|
    t.integer  "team_id"
    t.date     "pairing_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "pairing_days", ["pairing_date"], :name => "index_pairing_days_on_pairing_date", :order => {"pairing_date"=>:desc}
  add_index "pairing_days", ["team_id"], :name => "index_pairing_days_on_team_id"

  create_table "pairs", :force => true do |t|
    t.integer  "pairing_day_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "pairs", ["pairing_day_id"], :name => "index_pairs_on_pairing_day_id"

  create_table "team_memberships", :force => true do |t|
    t.integer  "team_id"
    t.integer  "employee_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "team_memberships", ["employee_id"], :name => "index_team_memberships_on_employee_id"
  add_index "team_memberships", ["team_id"], :name => "index_team_memberships_on_team_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "company_id"
  end

  add_index "teams", ["company_id", "name"], :name => "index_teams_on_company_id_and_name"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.boolean  "admin",                   :default => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "last_viewed_url"
    t.string   "sign_in_redirect_option", :default => "dashboard"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["uid"], :name => "index_users_on_uid"

end
