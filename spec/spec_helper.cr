require "spec"

require "crumble"
require "sqlite3"
require "orma"
require "crumble-orma"
require "crumble-stimulus"
require "crumble-turbo"
require "crumble-material"
require "crumble-web-push"

SPEC_DB_CONNECTION_STRING = "sqlite3:%3Amemory%3A?max_pool_size=1"
ENV["DATABASE_URL"] = SPEC_DB_CONNECTION_STRING
ENV["LEGAL_NOTICE_NAME"] = "Test Owner"
ENV["LEGAL_NOTICE_STREET"] = "Test Street 1"
ENV["LEGAL_NOTICE_CITY"] = "12345 Test City"
ENV["LEGAL_NOTICE_COUNTRY"] = "Germany"
ENV["LEGAL_NOTICE_REPRESENTED_BY"] = "Test Owner"
ENV["LEGAL_NOTICE_PHONE"] = "+49 123 456789"
ENV["LEGAL_NOTICE_FAX"] = ""
ENV["LEGAL_NOTICE_EMAIL"] = "test@example.com"

require "../src/session"
require "../src/push_notifications"
require "../src/styles/*"
require "../src/views/application_layout"
require "../src/pages/application_page"
require "../src/resources/application_resource"
require "../src/models/*"
require "../src/actions/lists/accept_access_push_notification"
require "../src/stimulus_controllers/*"
require "../src/policies/*"
require "../src/views/**"
require "../src/pages/**"
require "../src/resources/**"
require "../src/request_context"

class SpecViewHandler
  include Crumble::Server::ViewHandler

  getter request_ctx : Crumble::Server::TestRequestContext

  def initialize(method = "POST", resource = "/")
    @request_ctx = Crumble::Server::TestRequestContext.new(method: method, resource: resource)
  end

  def self.handle(ctx : Crumble::Server::RequestContext) : Bool
    false
  end

  def window_title : String?
    nil
  end
end

def build_handler_context(method = "POST", resource = "/")
  handler = SpecViewHandler.new(method, resource)
  Crumble::Server::HandlerContext.new(handler.request_ctx, handler)
end

module SpecSupport
  def self.reset_db!
    PushNotifications.configure!
    ListItem.db.exec("DELETE FROM list_items")
    ListAccessPermission.db.exec("DELETE FROM list_access_permissions")
    List.db.exec("DELETE FROM lists")
  end
end

List.continuous_migration!
ListItem.continuous_migration!
ListAccessPermission.continuous_migration!
