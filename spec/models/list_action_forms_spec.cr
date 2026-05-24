require "../spec_helper"

describe List::AddItemAction::Form do
  before_each do
    SpecSupport.reset_db!
  end

  it "rejects blank names" do
    form = List::AddItemAction::Form.from_www_form(build_handler_context, List.create(session_id: "session"), "name=")

    form.valid?.should be_false
    form.errors.should_not be_nil
    form.errors.not_nil!.should contain("name")
  end

  it "accepts non-empty names" do
    form = List::AddItemAction::Form.from_www_form(build_handler_context, List.create(session_id: "session"), "name=Milk")

    form.valid?.should be_true
  end
end

describe List::SetNameAction::Form do
  before_each do
    SpecSupport.reset_db!
  end

  it "rejects blank names" do
    form = List::SetNameAction::Form.from_www_form(build_handler_context, List.create(session_id: "session"), "name=")

    form.valid?.should be_false
    form.errors.should_not be_nil
    form.errors.not_nil!.should contain("name")
  end
end

describe ListAccessPermission::SetNameAction::Form do
  before_each do
    SpecSupport.reset_db!
  end

  it "rejects blank names" do
    list = List.create(session_id: "session")
    form = ListAccessPermission::SetNameAction::Form.from_www_form(build_handler_context, ListAccessPermission.create(list_id: list.id.value, session_id: "session"), "name=")

    form.valid?.should be_false
    form.errors.should_not be_nil
    form.errors.not_nil!.should contain("name")
  end

  it "accepts non-empty names" do
    list = List.create(session_id: "session")
    form = ListAccessPermission::SetNameAction::Form.from_www_form(build_handler_context, ListAccessPermission.create(list_id: list.id.value, session_id: "session"), "name=Alex")

    form.valid?.should be_true
  end
end
