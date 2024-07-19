class Lists::HeaderView
  getter list : List

  def initialize(@list); end

  css_class Container

  style do
    rule Container do
      display Flex
      prop("gap", 15.px)
    end
  end

  ToHtml.instance_template do
    div Container do
      list.name

      div do
        input(ListItemSearchController.searchInput_target, ListItemSearchController.sync_action("input"), name: "search", type: "text")
      end
    end
  end
end
