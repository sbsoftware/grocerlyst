class ListItem < Crumble::ORM
  id_column id : Int32?
  column name : String?
  column list_id : Int32?
  column active : Bool = true
  column created_at : Time?

  template :default_view do
    li SwitchController, SwitchController.resourceuri_value(ListItemSwitchResource.uri_path(id)), SwitchController.toggle_value(active), TagAttr.new("data-partial-id", "list-item##{id}") do
      div SwitchController.switch_action(ClickEvent) do
        strong { name }
      end
    end
  end
end
