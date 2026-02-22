class ListLayout < ApplicationLayout
  property list : List?

  body_attributes ListItemSearchController, ListItemSearchController.list_item_hider_controller_outlet("body"), ListItemHiderController, ListItemHiderController.list_target, Classes::HideCheckedItems

  def window_title
    list.try(&.name).try(&.value)
  end
end
