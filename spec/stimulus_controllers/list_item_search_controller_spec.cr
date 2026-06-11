require "../spec_helper"

describe ListItemSearchController do
  it "generates valid placement index assignments" do
    js = ListItemSearchController.to_js

    js.should_not contain("= if (")
    js.should contain("index = 0;if (event.params.placement == \"bottom\") {index = 1;}")
  end
end
