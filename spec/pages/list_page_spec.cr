require "../spec_helper"

describe ListPage do
  before_each do
    SpecSupport.reset_db!
  end

  it "redirects to the home page when the list is not accessible" do
    list = List.create(name: "Groceries", session_id: "another-session")
    ctx = Crumble::Server::TestRequestContext.new(method: "GET", resource: ListPage.uri_path(list_id: list.id.value))

    ListPage.handle(ctx).should be_true

    ctx.response.status_code.should eq(303)
    ctx.response.headers["Location"].should eq(HomePage.uri_path)
    ctx.session.last_used_list_id.should be_nil
  end

  it "renders an accessible list and stores it as last used" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: ListPage.uri_path(list_id: list.id.value))

    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)

    ListPage.handle(ctx).should be_true
    ctx.response.flush

    ctx.response.status_code.should eq(200)
    response_io.to_s.should contain("Weekly Shopping")
    ctx.session.last_used_list_id.should eq(list.id.value)
  end
end
