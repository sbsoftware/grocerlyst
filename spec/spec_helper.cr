require "spec"

require "crumble"
require "sqlite3"
require "orma"
require "crumble-orma"
require "crumble-stimulus"
require "crumble-turbo"
require "crumble-material"

SPEC_DB_CONNECTION_STRING = "sqlite3:%3Amemory%3A?max_pool_size=1"
ENV["DATABASE_URL"] = SPEC_DB_CONNECTION_STRING

require "../src/session"
require "../src/styles/*"
require "../src/views/application_layout"
require "../src/pages/application_page"
require "../src/models/*"
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
