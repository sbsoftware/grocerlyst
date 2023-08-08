class ListResource < ApplicationResource
  def layout_class
    nil
  end

  def layout
    ListLayout.new(list)
  end

  def index
    render list.items_view
  end

  def list
    List.find(id)
  end
end
