require "../../spec_helper"

describe Lists::ActionLogPage do
  before_each do
    SpecSupport.reset_db!
  end

  it "redirects when the list is not accessible" do
    list = List.create(name: "Private", session_id: "owner-session")
    ctx = Crumble::Server::TestRequestContext.new(resource: Lists::ActionLogPage.uri_path(list_id: list.id.value))

    Lists::ActionLogPage.handle(ctx).should be_true

    ctx.response.status_code.should eq(303)
    ctx.response.headers["Location"].should eq(HomePage.uri_path)
  end

  it "renders the action log for users with list access" do
    list = List.create(name: "Groceries", session_id: "owner-session")
    item = ListItem.create(list_id: list.id, name: "Milk")
    response_body = String.build do |io|
      ctx = Crumble::Server::TestRequestContext.new(response_io: io, resource: Lists::ActionLogPage.uri_path(list_id: list.id.value))
      ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s, name: "Alice")
      ListActionEvent.record!(list.id.value, ctx.session.id.to_s, "added", item)

      Lists::ActionLogPage.handle(ctx).should be_true
      ctx.response.status_code.should eq(200)
      ctx.response.flush
    end

    response_body.should contain("Action log")
    response_body.should contain("Alice")
    response_body.should contain("added")
    response_body.should contain("Milk")
  end
end
