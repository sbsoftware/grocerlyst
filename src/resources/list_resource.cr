class ListResource < ApplicationResource
  def layout_config(layout)
    super
    layout.window_title = list.name
    layout.page_title = list.default_view
  end

  def index
    render list.items_view
  end

  def list
    List.find(id)
  end
end
