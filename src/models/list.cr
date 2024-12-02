require "./list_item"
require "./list_access_permission"
require "../views/lists/*"
require "../actions/reorder_items_action"

class List < Orma::Record
  id_column id : Int32?
  column name : String?
  column session_id : String?
  column access_token : String?
  column created_at : Time?

  has_many_of ListAccessPermission

  def list_items
    ListItem.where({"list_id" => id}).order_by_sort_order!
  end

  create_child_action :add_item, ListItem, list_id, items_view do
    params :name

    form do
      input(ListItemSearchController.addInput_target, ListItemSearchController.filter_action("input"), name: "name", type: "text")
      input(ListItemSearchController.addSubmit_target, name: "Add Child", type: "submit")
    end
  end

  reorder_items_action :reorder_list_items, list_items, items_view

  def default_view
    Lists::MenuItem.new(self)
  end

  model_template :card_view do
    Lists::CardView.new(@model)
  end

  model_template :items_view do
    ul Classes::ListItems, ListItemSearchController.itemList_target, ListItemDragController, ListItemDragController.dragstart_action("dragstart"), ListItemDragController.dragover_action("dragover"), ListItemDragController.dragenter_action("dragenter"), ListItemDragController.drop_action("drop"), ListItemDragController.dragend_action("dragend") do
      reorder_list_items_action_template.to_html
      div Classes::ListItem, ListItemSearchController.addDisplayContainer_target, Classes::AddItemDisplayHidden, ListItem.active(false) do
        li do
          div Classes::AddItemForm do
            add_item_action_template.to_html
            span ListItemSearchController.add_action("click"), Crumble::Material::Classes::MaterialIcon do
              "add_circle"
            end
            span ListItemSearchController.disable_search_mode_action("click"), Crumble::Material::Classes::MaterialIcon do
              "cancel"
            end
          end
        end
      end
      list_items.to_a.each do |list_item|
        div Classes::ItemSearchable, ListItemSearchController.disable_search_mode_action("click") do
          list_item.default_view
        end
      end
    end
  end
end
