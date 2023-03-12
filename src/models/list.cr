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
      input(InputType::Text, {"name", "name"})
      input(InputType::Submit, {"name", "Add Child"})
    end
  end

  template :default_view do
    a href(ListResource.uri_path(id)) do
      name
    end
    main_docking_point
  end

  model_template :items_view do
    add_item_action.template
    ul do
      list_items.each do |list_item|
        list_item.default_view
      end
    end
  end
end
