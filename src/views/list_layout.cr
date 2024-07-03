class ListLayout < ApplicationLayout
  property list : List?

  def body_controllers
    [ListItemSearchController, ListItemHiderController]
  end

  def window_title
    list.try(&.name).try(&.value)
  end

  def headline
    list.try(&.header_view)
  end
end
