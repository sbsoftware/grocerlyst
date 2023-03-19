class ListResource < ApplicationResource
  def layout_config(layout)
    super
    layout.window_title = list.name.value
    layout.page_title = list.header_view
    layout.body_controllers << ListItemSearchController
  end

  def index
    render list.items_view
  end

  def list
    List.find(id)
  end
end
