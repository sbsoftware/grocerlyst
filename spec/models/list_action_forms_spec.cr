require "../spec_helper"

describe List::AddItemAction::Form do
  it "rejects blank names" do
    form = List::AddItemAction::Form.from_www_form(build_handler_context, "name=")

    form.valid?.should be_false
    form.errors.should_not be_nil
    form.errors.not_nil!.should contain("name")
  end

  it "accepts non-empty names" do
    form = List::AddItemAction::Form.from_www_form(build_handler_context, "name=Milk")

    form.valid?.should be_true
  end
end

describe List::SetNameAction::Form do
  it "rejects blank names" do
    form = List::SetNameAction::Form.from_www_form(build_handler_context, "name=")

    form.valid?.should be_false
    form.errors.should_not be_nil
    form.errors.not_nil!.should contain("name")
  end
end
