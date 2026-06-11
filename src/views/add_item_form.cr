class AddItemForm
  getter list : List
  getter placement : String

  def initialize(@list, @placement); end

  ToHtml.instance_template do
    div ListItemSearchController.addDisplayContainer_target, Classes::AddItemDisplayHidden, ListItem.active(false) do
      Crumble::Material::ListItem.to_html do
        li Classes::ListItem do
          div Classes::AddItemForm do
            form action: List::AddItemAction.uri_path(list.id), method: "POST" do
              input name: "placement", type: "hidden", value: placement
              input ListItemSearchController.addInput_target, ListItemSearchController.param("placement", placement), ListItemSearchController.filter_action("input"), ListItemSearchController.add_action("keydown.enter"), ListItemSearchController.disable_search_mode_action("keydown.esc"), name: "name", type: "text"
              input ListItemSearchController.addSubmit_target, name: "Add Child", type: "submit"
            end
            span ListItemSearchController.param("placement", placement), ListItemSearchController.add_action("click") do
              Crumble::Material::Icon.new("add_circle")
            end
            span ListItemSearchController.disable_search_mode_action("click") do
              Crumble::Material::Icon.new("cancel")
            end
          end
        end
      end
    end
  end
end
