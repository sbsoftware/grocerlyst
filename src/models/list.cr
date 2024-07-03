require "./list_item"
require "../views/lists/*"

class List < Orma::Record
  id_column id : Int32?
  column name : String?
  column created_at : Time?

  def list_items
    ListItem.where({"list_id" => id})
  end

  create_child_action :add_item, ListItem, list_id, items_view do
    params :name

    form do
      input(ListItemSearchController.addInput_target, name: "name", type: "text")
      input(ListItemSearchController.addSubmit_target, name: "Add Child", type: "submit")
    end
  end

  def default_view
    Lists::MenuItem.new(self)
  end

  def header_view
    Lists::HeaderView.new(self)
  end

  model_template :items_view do
    div Classes::AddItemForm do
      add_item_action.template.to_html
    end
    ul Classes::ListItems, ListItemSearchController.itemList_target, ListItemHiderController.list_target, ListItemDragController, ListItemDragController.dragstart_action("dragstart"), ListItemDragController.dragover_action("dragover"), ListItemDragController.dragenter_action("dragenter"), ListItemDragController.drop_action("drop"), ListItemDragController.dragend_action("dragend") do
      li ListItemSearchController.add_action("click"), ListItemSearchController.addDisplayContainer_target, Classes::AddItemDisplayHidden do
        strong ListItemSearchController.addDisplay_target
      end
      list_items.to_a.each do |list_item|
        list_item.default_view
      end
    end
  end
end
