class List < Crumble::ORM::Base
  id_column id : Int32?
  column name : String?
  column created_at : Time?

  def list_items
    ListItem.where({"list_id" => id})
  end

  template :default_view do
    a href(ListResource.uri_path(id)) do
      name
    end
    main_docking_point
  end

  model_template :items_view do
    ul do
      list_items.each do |list_item|
        list_item.default_view
      end
    end
  end
end
