class ListResource < ApplicationResource
  layout ListLayout

  def resource_layout
    layout = previous_def
    layout.list = list
    layout
  end

  def show
    render list.items_view
  end

  def list
    List.find(id)
  end
end
