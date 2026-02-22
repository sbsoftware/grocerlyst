require "../spec_helper"

describe ListResource do
  before_each do
    List.continuous_migration!
    ListAccessPermission.continuous_migration!
    ListItem.continuous_migration!

    ListItem.db.exec("DELETE FROM list_items")
    ListAccessPermission.db.exec("DELETE FROM list_access_permissions")
    List.db.exec("DELETE FROM lists")
  end

  it "renders the list for accessible users and updates last_used_list_id" do
    list = List.create(name: "Resource Spec List", session_id: "owner-session")

    response_body = String.build do |io|
      request_ctx = Crumble::Server::TestRequestContext.new(
        response_io: io,
        resource: ListResource.uri_path(list.id)
      )

      ListAccessPermission.create(
        list_id: list.id,
        session_id: request_ctx.session.id.to_s,
        name: "Spec Member"
      )

      ListResource.handle(request_ctx).should eq(true)
      request_ctx.response.status_code.should eq(200)
      request_ctx.session.last_used_list_id.should eq(list.id.value)
      request_ctx.response.flush
    end

    response_body.should contain("Resource Spec List")
    response_body.should contain("id=\"#{Crumble::Material::TopAppBar::TopAppBarId}\"")
    response_body.should contain("arrow_back")
    response_body.should contain(Lists::MembersPage.uri_path(list_id: list.id))
  end

  it "redirects to home when the user has no access to the list" do
    list = List.create(name: "Private List", session_id: "owner-session")

    request_ctx = Crumble::Server::TestRequestContext.new(
      resource: ListResource.uri_path(list.id)
    )

    ListResource.handle(request_ctx).should eq(true)
    request_ctx.response.status_code.should eq(303)
    request_ctx.response.headers["Location"].should eq(HomePage.uri_path)
  end
end
