require "./list_item"

class List < Crumble::ORM::Base
  id_column id : Int32?
  column name : String?
  column created_at : Time?

  def list_items
    ListItem.where({"list_id" => id})
  end

  create_child_action :add_item, ListItem, list_id, items_view do
    params :name

    form do
      input(InputType::Text, ListItemSearchController.addInput_target, {"name", "name"})
      input(InputType::Submit, ListItemSearchController.addSubmit_target, {"name", "Add Child"})
    end
  end

  template :default_view do
    a href(ListResource.uri_path(id)) do
      name
    end
    main_docking_point
  end

  template :header_view do
    div Classes::HeaderContainer do
      a href(ListResource.uri_path(id)) do
        name
      end
      div do
        input(InputType::Text, ListItemSearchController.searchInput_target, ListItemSearchController.sync_action(InputEvent), {"name", "search"})
      end
    end
  end

  model_template :items_view do
    div Classes::AddItemForm do
      add_item_action.template
    end
    ul ListItemSearchController.itemList_target do
      li ListItemSearchController.add_action(ClickEvent), ListItemSearchController.addDisplayContainer_target, Classes::AddItemDisplayHidden do
        strong ListItemSearchController.addDisplay_target
      end
      list_items.each do |list_item|
        div Classes::ItemSearchable do
          list_item.default_view
        end
      end
    end
  end
end
