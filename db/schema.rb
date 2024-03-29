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

ActiveRecord::Schema.define(version: 2021_12_21_152517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "minecraft_backups", force: :cascade do |t|
    t.bigint "world_id", null: false
    t.boolean "autosave", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.index ["parent_id"], name: "index_minecraft_backups_on_parent_id"
    t.index ["world_id"], name: "index_minecraft_backups_on_world_id"
  end

  create_table "minecraft_jars", force: :cascade do |t|
    t.string "version", null: false
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["version"], name: "index_minecraft_jars_on_version", unique: true
  end

  create_table "minecraft_logs", force: :cascade do |t|
    t.bigint "server_id", null: false
    t.string "text", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["server_id"], name: "index_minecraft_logs_on_server_id"
  end

  create_table "minecraft_modders", force: :cascade do |t|
    t.string "version", null: false
    t.string "name", null: false
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "version"], name: "index_minecraft_modders_on_name_and_version", unique: true
  end

  create_table "minecraft_mods", force: :cascade do |t|
    t.string "version", null: false
    t.string "name", null: false
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "version"], name: "index_minecraft_mods_on_name_and_version", unique: true
  end

  create_table "minecraft_mods_servers", id: false, force: :cascade do |t|
    t.bigint "mod_id", null: false
    t.bigint "server_id", null: false
    t.index ["server_id", "mod_id"], name: "index_minecraft_mods_servers_on_server_id_and_mod_id"
  end

  create_table "minecraft_servers", force: :cascade do |t|
    t.string "host", null: false
    t.bigint "backup_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "jar_id"
    t.bigint "modder_id"
    t.bigint "connections", default: 0, null: false
    t.datetime "last_active_at"
    t.string "max_idle_time"
    t.json "properties", default: {}, null: false
    t.json "ops", default: [], null: false, array: true
    t.index ["backup_id"], name: "index_minecraft_servers_on_backup_id"
    t.index ["host"], name: "index_minecraft_servers_on_host"
    t.index ["jar_id"], name: "index_minecraft_servers_on_jar_id"
    t.index ["modder_id"], name: "index_minecraft_servers_on_modder_id"
  end

  create_table "minecraft_worlds", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_minecraft_worlds_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "oauth_provider"
    t.string "oauth_uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "confirmed", default: false, null: false
    t.index ["email"], name: "index_users_on_email"
  end

  create_table "wireguard_keys", force: :cascade do |t|
    t.string "private_key", null: false
    t.string "public_key", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "wireguard_networks", force: :cascade do |t|
    t.string "ip_address", null: false
    t.string "host", null: false
    t.bigint "key_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["host"], name: "index_wireguard_networks_on_host"
    t.index ["key_id"], name: "index_wireguard_networks_on_key_id"
  end

  create_table "wireguard_peers", force: :cascade do |t|
    t.string "name", null: false
    t.string "ip_address", null: false
    t.bigint "network_id", null: false
    t.bigint "key_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ip_address", "network_id"], name: "index_wireguard_peers_on_ip_address_and_network_id", unique: true
    t.index ["key_id"], name: "index_wireguard_peers_on_key_id"
    t.index ["name"], name: "index_wireguard_peers_on_name"
    t.index ["network_id"], name: "index_wireguard_peers_on_network_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
