require "../../spec_helper"

describe Lists::MembersPage do
  before_each do
    List.continuous_migration!
    ListAccessPermission.continuous_migration!

    ListAccessPermission.db.exec("DELETE FROM list_access_permissions")
    List.db.exec("DELETE FROM lists")
  end

  it "renders the members page with list members" do
    list = List.create(name: "Members Spec List", session_id: "owner-session")

    response_body = String.build do |io|
      request_ctx = Crumble::Server::TestRequestContext.new(
        response_io: io,
        resource: Lists::MembersPage.uri_path(list_id: list.id)
      )

      ListAccessPermission.create(list_id: list.id, session_id: request_ctx.session.id.to_s, name: "Alice")
      ListAccessPermission.create(list_id: list.id, session_id: "guest-session", name: "Bob")

      Lists::MembersPage.handle(request_ctx).should eq(true)
      request_ctx.response.status_code.should eq(200)
      request_ctx.response.flush
    end

    response_body.should contain("Members")
    response_body.should contain("Alice")
    response_body.should contain("Bob")
    response_body.should contain("list-member-edit-toggle")
  end
end
