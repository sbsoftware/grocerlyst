require "../spec_helper"

describe ListItemResource do
  before_each do
    SpecSupport.reset_db!
  end

  it "updates an item through its numeric member route" do
    list = List.create(name: "Groceries", session_id: "session")
    item = ListItem.create(list_id: list.id, name: "Milk")
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: ListItemResource.uri_path(item.id.value), body: "name=Bread")

    ListItemResource.handle(ctx).should be_true

    ListItem.find(item.id).name.not_nil!.value.should eq("Bread")
  end

  it "does not match a nonnumeric item id" do
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: "/list_item/invalid", body: "name=Bread")

    ListItemResource.handle(ctx).should be_false
  end
end
