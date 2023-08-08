class ListLayout < ApplicationLayout
  getter list : List?

  def initialize(@list)
  end

  def body_controllers
    [ListItemSearchController]
  end

  def window_title
    list.try(&.name).try(&.value)
  end

  def page_title
    list.try(&.header_view)
  end
end
