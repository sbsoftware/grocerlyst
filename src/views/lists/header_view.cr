class Lists::HeaderView
  getter list : List

  def initialize(@list); end

  ToHtml.instance_template do
    div Classes::HeaderContainer do
      list.name

      div do
        input(ListItemSearchController.searchInput_target, ListItemSearchController.sync_action("input"), name: "search", type: "text")
      end
    end
  end
end
