require "../spec_helper"

describe HomePage do
  before_each do
    SpecSupport.reset_db!
  end

  it "renders the home page" do
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: HomePage.uri_path)

    HomePage.handle(ctx).should be_true
    ctx.response.flush

    ctx.response.status_code.should eq(200)
    response_io.to_s.should contain("Collaborative Shopping")
  end

  it "redirects to the last used list when there is no referer" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    ctx = Crumble::Server::TestRequestContext.new(method: "GET", resource: HomePage.uri_path)
    ctx.session.update!(last_used_list_id: list.id.value)

    HomePage.handle(ctx).should be_true

    ctx.response.status_code.should eq(303)
    ctx.response.headers["Location"].should eq(ListPage.uri_path(list_id: list.id.value))
  end
end
