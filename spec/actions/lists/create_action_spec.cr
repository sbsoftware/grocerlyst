require "../../spec_helper"

describe Lists::CreateAction do
  before_each do
    SpecSupport.reset_db!
  end

  it "creates a list with access permission and redirects to its page" do
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: Lists::CreateAction.uri_path)

    Lists::CreateAction.handle(ctx).should be_true

    created_list = List.where(session_id: ctx.session.id.to_s).first
    created_list.should_not be_nil

    list = created_list.not_nil!
    list.name.should_not be_nil
    list.name.not_nil!.value.should match(/List from \d{4}-\d{2}-\d{2}/)
    ListAccessPermission.where(list_id: list.id, session_id: ctx.session.id.to_s).first.should_not be_nil

    ctx.response.status_code.should eq(303)
    ctx.response.headers["Location"].should eq(ListPage.uri_path(list_id: list.id.value))
  end
end
