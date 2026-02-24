require "spec"
require "crumble"
require "sqlite3"
require "orma"
require "crumble-orma"
require "crumble-stimulus"
require "crumble-turbo"
require "crumble-material"
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

TEST_DB_CONNECTION_STRING = "sqlite3:%3Amemory%3A?max_pool_size=1"
TEST_DB                   = DB.open(TEST_DB_CONNECTION_STRING)

class List
  def self.db_connection_string
    TEST_DB_CONNECTION_STRING
  end

  def self.db
    TEST_DB
  end
end

class ListItem
  def self.db_connection_string
    TEST_DB_CONNECTION_STRING
  end

  def self.db
    TEST_DB
  end
end

class ListAccessPermission
  def self.db_connection_string
    TEST_DB_CONNECTION_STRING
  end

  def self.db
    TEST_DB
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
