# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090110060728) do

  create_table "area", :force => true do |t|
    t.integer "areaid",                 :null => false
    t.string  "area",     :limit => 20, :null => false
    t.integer "fatherid",               :null => false
  end

  create_table "areas", :force => true do |t|
    t.integer "areaid",    :null => false
    t.integer "father_id", :null => false
    t.string  "area",      :null => false
  end

  create_table "article_categories", :force => true do |t|
    t.string "name"
    t.string "category"
  end

  create_table "articles", :force => true do |t|
    t.string   "title",                              :null => false
    t.string   "display_title"
    t.string   "sub_title"
    t.string   "permalink"
    t.string   "author"
    t.string   "source"
    t.text     "excerpt"
    t.string   "redirect_url"
    t.boolean  "status",          :default => true
    t.integer  "channel_id"
    t.string   "cached_tag_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "top",             :default => false
    t.boolean  "sticky",          :default => false
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "category_id"
  end

  add_index "articles", ["channel_id"], :name => "index_articles_on_channel_id"
  add_index "articles", ["permalink"], :name => "index_articles_on_permalink"

  create_table "assets", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "type"
    t.string   "content_type"
    t.string   "filename"
    t.string   "path"
    t.string   "category"
    t.integer  "parent_id"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_articles", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "keywords"
    t.string   "text_filter"
    t.string   "permalink"
    t.text     "body"
    t.text     "body_html"
    t.text     "extended"
    t.text     "excerpt"
    t.text     "extended_html"
    t.integer  "allow_comments"
    t.integer  "allow_pings"
    t.integer  "published",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_configs", :force => true do |t|
    t.integer "user_id",                                :null => false
    t.string  "blog_name"
    t.integer "blog_perpage",    :default => 20
    t.integer "comment_perpage", :default => 50
    t.string  "theme_name",      :default => "default"
    t.string  "announcement"
  end

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "keywords"
    t.string   "text_filter"
    t.string   "permalink"
    t.text     "body"
    t.text     "body_html"
    t.text     "extended"
    t.text     "excerpt"
    t.text     "extended_html"
    t.integer  "allow_comments"
    t.integer  "allow_pings"
    t.integer  "published",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "if_top",         :default => 0
    t.integer  "category_id",    :default => 0
    t.integer  "user_id",                       :null => false
    t.integer  "comment_count",  :default => 0
    t.integer  "view_count",     :default => 0
  end

  create_table "callers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "user_id",                   :null => false
    t.integer "blog_count", :default => 0
  end

  create_table "channels", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "permalink"
    t.text     "body"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.integer  "template_id"
    t.integer  "article_template_id"
    t.integer  "content_template_id"
    t.integer  "channels_count",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mimetype"
  end

  add_index "channels", ["name"], :name => "index_channels_on_name"
  add_index "channels", ["parent_id"], :name => "index_channels_on_parent_id"
  add_index "channels", ["permalink"], :name => "index_channels_on_permalink"

  create_table "cities", :force => true do |t|
    t.integer "father_id", :null => false
    t.string  "city"
    t.integer "city_id",   :null => false
  end

  create_table "city", :force => true do |t|
    t.integer "cityid",                 :null => false
    t.string  "city",     :limit => 20, :null => false
    t.integer "fatherid",               :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "email"
    t.string   "url"
    t.string   "ip"
    t.text     "body"
    t.text     "body_html"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",      :default => 0
    t.integer  "blog_id",                     :null => false
    t.integer  "blog_user_id"
  end

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "page",       :default => 1
    t.integer  "article_id",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["article_id", "page"], :name => "index_contents_on_article_id_and_page"

  create_table "craw_jobs", :force => true do |t|
    t.integer "site_id",     :default => 0
    t.integer "crawler_pid", :default => 0
  end

  create_table "files", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "type"
    t.string   "content_type"
    t.string   "filename"
    t.string   "path"
    t.string   "category"
    t.integer  "parent_id"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friends", ["user_id", "friend_id"], :name => "index_friends_on_user_id_and_friend_id", :unique => true

  create_table "gift_users", :force => true do |t|
    t.integer "user_id"
    t.integer "friend_id"
    t.integer "gift_id"
    t.string  "post"
    t.integer "send_mode"
  end

  create_table "gifts", :force => true do |t|
    t.string  "name"
    t.integer "type", :default => 0
    t.string  "icon"
  end

  create_table "group_members", :force => true do |t|
    t.integer  "group_id",   :null => false
    t.integer  "user_id",    :null => false
    t.string   "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_roles", :force => true do |t|
    t.integer "group_id", :null => false
    t.integer "role_id",  :null => false
  end

  create_table "group_users", :force => true do |t|
    t.integer "group_id", :null => false
    t.integer "user_id",  :null => false
  end

  create_table "groups", :force => true do |t|
    t.string  "group_name",                      :null => false
    t.integer "status",           :default => 0, :null => false
    t.integer "inherit_group_id", :default => 0
    t.text    "description"
  end

  create_table "links", :force => true do |t|
    t.string  "name"
    t.string  "url"
    t.string  "category"
    t.text    "memo"
    t.string  "filename"
    t.integer "size"
    t.string  "content_type"
  end

  add_index "links", ["category"], :name => "index_links_on_category"
  add_index "links", ["name"], :name => "index_links_on_name"

  create_table "messages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",      :limit => 125, :null => false
    t.string   "content",                   :null => false
    t.integer  "user_id",                   :null => false
  end

  create_table "mush_crawlers", :force => true do |t|
    t.string  "crawler_name",                :null => false
    t.string  "crawler_path",                :null => false
    t.integer "craw_freq",                   :null => false
    t.integer "status",       :default => 0
  end

  create_table "personal_sidebars", :force => true do |t|
    t.string  "title",       :null => false
    t.text    "template",    :null => false
    t.text    "description"
    t.integer "bar_index"
  end

  create_table "photos", :force => true do |t|
    t.string  "title"
    t.string  "tag_list",       :limit => 124
    t.text    "description"
    t.string  "orignal_link",                                 :null => false
    t.string  "mid_link",                                     :null => false
    t.string  "thumbnail_link",                               :null => false
    t.integer "shared",                        :default => 1
    t.integer "user_id",                       :default => 0
  end

  create_table "province", :force => true do |t|
    t.integer "provinceid",               :null => false
    t.string  "province",   :limit => 20, :null => false
  end

  create_table "provinces", :force => true do |t|
    t.integer "provinceid", :null => false
    t.string  "province"
  end

  create_table "regards", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string  "role_name",                  :null => false
    t.string  "e_name",                     :null => false
    t.text    "description"
    t.integer "status",      :default => 0, :null => false
  end

  create_table "scriptlets", :force => true do |t|
    t.string   "name"
    t.string   "type_name"
    t.string   "template_type"
    t.string   "category"
    t.text     "template"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sidebars", :force => true do |t|
    t.string  "bar_name",                   :null => false
    t.integer "user_id",                    :null => false
    t.integer "bar_index"
    t.text    "description"
    t.text    "settings"
    t.string  "sidebar_id",  :limit => 125, :null => false
  end

  create_table "sites", :force => true do |t|
    t.string   "site_name"
    t.string   "site_url"
    t.integer  "status",           :default => 0
    t.integer  "state",            :default => 0
    t.integer  "time_out",         :default => 120
    t.datetime "last_finish_time", :default => '2008-09-13 01:09:23'
    t.integer  "craw_freq",        :default => 86400
    t.integer  "request_freq",     :default => 1
    t.integer  "craw_now"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.string  "category"
    t.text    "top"
    t.text    "bottom"
    t.integer "position"
  end

  add_index "tags", ["category"], :name => "index_tags_on_category"

  create_table "templates", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "category"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "themes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topic_comments", :force => true do |t|
    t.integer  "topic_id",   :null => false
    t.integer  "user_id",    :null => false
    t.string   "user_name",  :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", :force => true do |t|
    t.string   "title",                        :null => false
    t.string   "user_name",                    :null => false
    t.integer  "user_id"
    t.integer  "view_count"
    t.integer  "comment_count", :default => 0
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_group_id",                :null => false
    t.integer  "admin_id",                     :null => false
  end

  create_table "user_groups", :force => true do |t|
    t.string   "title",                       :null => false
    t.string   "user_name",                   :null => false
    t.integer  "user_id",                     :null => false
    t.text     "description"
    t.string   "icon"
    t.string   "category"
    t.integer  "topic_count",  :default => 0
    t.integer  "member_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_profiles", :force => true do |t|
    t.string   "real_name"
    t.integer  "user_id",                                      :null => false
    t.string   "photo"
    t.text     "adress"
    t.text     "introduction"
    t.string   "company_name"
    t.string   "position"
    t.string   "zipcode"
    t.string   "tel"
    t.string   "mobile"
    t.string   "fax"
    t.string   "web_site"
    t.integer  "vocation_id"
    t.integer  "company_nature"
    t.integer  "interested"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sex",                           :default => 0
    t.string   "city",           :limit => 125,                :null => false
  end

  create_table "user_votes", :force => true do |t|
    t.integer  "voter_id"
    t.integer  "vote_value"
    t.datetime "created_at"
  end

  create_table "users", :force => true do |t|
    t.string   "user_name",                       :null => false
    t.string   "hashed_password",                 :null => false
    t.string   "email",                           :null => false
    t.string   "salt",                            :null => false
    t.datetime "created_at"
    t.integer  "status",          :default => 0,  :null => false
    t.string   "pwd_question",    :default => ""
    t.string   "pwd_anwser",      :default => ""
    t.string   "theme_name"
  end

  create_table "vocations", :force => true do |t|
    t.string "vocation_name", :null => false
  end

  create_table "vote_options", :force => true do |t|
    t.integer "voter_id"
    t.integer "title"
    t.integer "value"
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id",                      :null => false
    t.string   "title"
    t.integer  "multi_selcect", :default => 1
    t.integer  "sex_limit",     :default => 0
    t.integer  "roll_limt",     :default => 0
    t.datetime "expire_time"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
