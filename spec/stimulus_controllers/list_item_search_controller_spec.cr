require "../spec_helper"

describe ListItemSearchController do
  it "generates valid placement index assignments" do
    js = ListItemSearchController.to_js

    js.should_not contain("= if (")
    js.should contain("index = 0;if (event.params.placement == \"bottom\") {index = 1;}")
  end

  it "generates client-side top add button visibility based on visible item count" do
    js = ListItemSearchController.to_js

    js.should contain("visible_item_count()")
    js.should contain(".classes--item-searchable [data-orma-list-item-active~='false']")
    js.should contain("document.body.classList.contains(\"classes--hide-checked-items\")")
    js.should contain("return count;")
    js.should contain("enable_search_mode(event)")
    js.should_not contain(".try(")
    js.should contain("this.visible_item_count() > 8")
    js.should contain("update_top_add_button()")
  end
end
