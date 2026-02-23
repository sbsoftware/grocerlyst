require "spec"
require "crumble"
require "sqlite3"
require "orma"
require "crumble-orma"
require "crumble-stimulus"
require "crumble-turbo"
require "crumble-material"
require "file_utils"
require "../src/session"
require "../src/styles/*"
require "../src/models/*"
require "../src/stimulus_controllers/*"
require "../src/policies/*"
require "../src/views/**"
require "../src/pages/**"
require "../src/actions/**"
require "../src/resources/**"
require "../src/request_context"
require "../lib/crumble/spec/test_request_context"

TEST_DB_PATH              = "./tmp/spec.db"
TEST_DB_CONNECTION_STRING = "sqlite3://#{TEST_DB_PATH}"

FileUtils.mkdir_p("./tmp")
File.delete(TEST_DB_PATH) if File.exists?(TEST_DB_PATH)

class List
  def self.db_connection_string
    TEST_DB_CONNECTION_STRING
  end
end

class ListItem
  def self.db_connection_string
    TEST_DB_CONNECTION_STRING
  end
end

class ListAccessPermission
  def self.db_connection_string
    TEST_DB_CONNECTION_STRING
  end
end

module SpecSupport
  def self.reset_db!
    List.db.exec("DELETE FROM list_items")
    List.db.exec("DELETE FROM list_access_permissions")
    List.db.exec("DELETE FROM lists")
  end
end

List.continuous_migration!
ListItem.continuous_migration!
ListAccessPermission.continuous_migration!
