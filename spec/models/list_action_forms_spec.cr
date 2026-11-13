require "../spec_helper"

describe List::AddItemAction::Form do
  before_each do
    SpecSupport.reset_db!
  end

  it "rejects blank names" do
    form = List::AddItemAction::Form.from_www_form(build_handler_context, List.create(name: "Groceries", session_id: "session"), "name=")

    form.valid?.should be_false
    form.errors.should_not be_nil
    form.errors.not_nil!.should contain("name")
  end

  it "accepts non-empty names" do
    form = List::AddItemAction::Form.from_www_form(build_handler_context, List.create(name: "Groceries", session_id: "session"), "name=Milk")

    form.valid?.should be_true
  end
end

describe List::AddItemAction do
  before_each do
    SpecSupport.reset_db!
  end

  it "inserts items submitted from the top form at the top" do
    list = List.create(name: "Groceries", session_id: "session")
    ListItem.create(list_id: list.id.value, name: "Existing")
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: List::AddItemAction.uri_path(list.id), headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"}, body: URI::Params.encode({name: "Top", placement: "top"}))

    List::AddItemAction.handle(ctx)

    list.list_items.map { |item| item.name.try(&.value) }.should eq(["Top", "Existing"])
  end

  it "inserts items submitted from the bottom form at the bottom" do
    list = List.create(name: "Groceries", session_id: "session")
    ListItem.create(list_id: list.id.value, name: "First", sort_order: 1)
    ListItem.create(list_id: list.id.value, name: "Second", sort_order: 2)
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: List::AddItemAction.uri_path(list.id), headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"}, body: URI::Params.encode({name: "Bottom", placement: "bottom"}))

    List::AddItemAction.handle(ctx)

    list.list_items.map { |item| item.name.try(&.value) }.should eq(["First", "Second", "Bottom"])
  end
end

describe List::SetNameAction::Form do
  before_each do
    SpecSupport.reset_db!
  end

  it "rejects blank names" do
    form = List::SetNameAction::Form.from_www_form(build_handler_context, List.create(name: "Groceries", session_id: "session"), "name=")

    form.valid?.should be_false
    form.errors.should_not be_nil
    form.errors.not_nil!.should contain("name")
  end
end

describe List::AcceptAccessAction::Form do
  before_each do
    SpecSupport.reset_db!
  end

  it "renders the model access token into the action form" do
    list = List.create(name: "Groceries", session_id: "session")

    html = list.accept_access_action_template(build_handler_context).to_html

    html.should contain(%(name="access_token" value="#{list.access_token.value}"))
  end
end

describe ListAccessPermission::SetNameAction::Form do
  before_each do
    SpecSupport.reset_db!
  end

  it "rejects blank names" do
    list = List.create(name: "Groceries", session_id: "session")
    form = ListAccessPermission::SetNameAction::Form.from_www_form(build_handler_context, ListAccessPermission.create(list_id: list.id, session_id: "session"), "name=")

    form.valid?.should be_false
    form.errors.should_not be_nil
    form.errors.not_nil!.should contain("name")
  end

  it "accepts non-empty names" do
    list = List.create(name: "Groceries", session_id: "session")
    form = ListAccessPermission::SetNameAction::Form.from_www_form(build_handler_context, ListAccessPermission.create(list_id: list.id, session_id: "session"), "name=Alex")

    form.valid?.should be_true
  end
end

describe ListAccessPermission::SetNameAction do
  before_each do
    SpecSupport.reset_db!
  end

  it "updates the member name and refreshes the form and parent members view" do
    list = List.create(name: "Groceries", session_id: "session")
    response_io = IO::Memory.new
    member = ListAccessPermission.create(list_id: list.id, session_id: "session")
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "POST", resource: ListAccessPermission::SetNameAction.uri_path(member.id.value), headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"}, body: "name=Alex")
    member.update(session_id: ctx.session.id.to_s)

    ListAccessPermission::SetNameAction.handle(ctx).should be_true
    ctx.response.flush

    ListAccessPermission.find(member.id).name.not_nil!.value.should eq("Alex")
    response_io.to_s.should contain(%(data-model-template-id="ListAccessPermission##{member.id.value}-set_name_form"))
    response_io.to_s.should contain(%(data-model-template-id="List##{list.id.value}-members_view"))
  end
end
