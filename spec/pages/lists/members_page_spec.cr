require "../../spec_helper"

LISTS_MEMBERS_PAGE_SPEC_DB_CONNECTION = "sqlite3:///tmp/ekl_members_page_spec.db"

class List
  def self.db_connection_string
    LISTS_MEMBERS_PAGE_SPEC_DB_CONNECTION
  end
end

class ListAccessPermission
  def self.db_connection_string
    LISTS_MEMBERS_PAGE_SPEC_DB_CONNECTION
  end
end

describe Lists::MembersPage do
  before_each do
    List.continuous_migration!
    ListAccessPermission.continuous_migration!

    ListAccessPermission.db.exec("DELETE FROM list_access_permissions")
    List.db.exec("DELETE FROM lists")
  end

  it "renders the members page with list members" do
    list = List.create(name: "Members Spec List", session_id: "owner-session")
    ListAccessPermission.create(list_id: list.id, session_id: "owner-session", name: "Alice")
    ListAccessPermission.create(list_id: list.id, session_id: "guest-session", name: "Bob")

    response_body = String.build do |io|
      request_ctx = Crumble::Server::TestRequestContext.new(
        response_io: io,
        resource: Lists::MembersPage.uri_path(list_id: list.id)
      )

      Lists::MembersPage.handle(request_ctx).should eq(true)
      request_ctx.response.status_code.should eq(200)
      request_ctx.response.flush
    end

    response_body.should contain("Members")
    response_body.should contain("Alice")
    response_body.should contain("Bob")
  end
end
