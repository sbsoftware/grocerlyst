require "../spec_helper"

describe ListActionEvent do
  before_each do
    SpecSupport.reset_db!
  end

  it "records an event when an item is added" do
    list = List.create(name: "Groceries", session_id: "owner-session")
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: List::AddItemAction.uri_path(list.id.value), body: URI::Params.encode({name: "Milk"}))

    List::AddItemAction.handle(ctx).should be_true

    item = ListItem.where(list_id: list.id, name: "Milk").first
    event = ListActionEvent.where(list_id: list.id).first
    event.actor_session_id.value.should eq(ctx.session.id.to_s)
    event.action_type.value.should eq("added")
    event.item_id.not_nil!.value.should eq(item.id.value)
    event.item_name.not_nil!.value.should eq("Milk")
    event.created_at.should_not be_nil
  end

  it "records an event when adding an inactive item activates it" do
    list = List.create(name: "Groceries", session_id: "owner-session")
    item = ListItem.create(list_id: list.id, name: "Milk", active: false)
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: List::AddItemAction.uri_path(list.id.value), body: URI::Params.encode({name: "Milk"}))

    List::AddItemAction.handle(ctx).should be_true

    ListItem.find(item.id).active.value.should be_true
    event = ListActionEvent.where(list_id: list.id).first
    event.action_type.value.should eq("activated")
    event.item_id.not_nil!.value.should eq(item.id.value)
  end

  it "records an event when an item is deactivated" do
    list = List.create(name: "Groceries", session_id: "owner-session")
    item = ListItem.create(list_id: list.id, name: "Milk", active: true)
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: ListItem::SwitchAction.uri_path(item.id.value), body: URI::Params.encode({active: "false"}))

    ListItem::SwitchAction.handle(ctx).should be_true

    ListItem.find(item.id).active.value.should be_false
    event = ListActionEvent.where(list_id: list.id).first
    event.actor_session_id.value.should eq(ctx.session.id.to_s)
    event.action_type.value.should eq("deactivated")
    event.item_id.not_nil!.value.should eq(item.id.value)
    event.item_name.not_nil!.value.should eq("Milk")
  end

  it "records an event when an item is activated" do
    list = List.create(name: "Groceries", session_id: "owner-session")
    item = ListItem.create(list_id: list.id, name: "Milk", active: false)
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: ListItem::SwitchAction.uri_path(item.id.value), body: URI::Params.encode({active: "true"}))

    ListItem::SwitchAction.handle(ctx).should be_true

    ListItem.find(item.id).active.value.should be_true
    event = ListActionEvent.where(list_id: list.id).first
    event.actor_session_id.value.should eq(ctx.session.id.to_s)
    event.action_type.value.should eq("activated")
    event.item_id.not_nil!.value.should eq(item.id.value)
    event.item_name.not_nil!.value.should eq("Milk")
  end

  it "records an event when an item is deleted" do
    list = List.create(name: "Groceries", session_id: "owner-session")
    item = ListItem.create(list_id: list.id, name: "Milk")
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: ListItem::RemoveAction.uri_path(item.id.value))
    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)

    ListItem::RemoveAction.handle(ctx).should be_true

    ListItem.where(id: item.id).first?.should be_nil
    event = ListActionEvent.where(list_id: list.id).first
    event.actor_session_id.value.should eq(ctx.session.id.to_s)
    event.action_type.value.should eq("deleted")
    event.item_id.not_nil!.value.should eq(item.id.value)
    event.item_name.not_nil!.value.should eq("Milk")
  end
end
