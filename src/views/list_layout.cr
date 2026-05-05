class ListLayout < ApplicationLayout
  # This layout is rendered for ListPage handlers and can read the model directly from there.
  def list : List?
    ctx.handler.as?(ListPage).try(&.list)
  end

  body_attributes ListItemSearchController, ListItemSearchController.list_item_hider_controller_outlet("body"), ListItemHiderController, ListItemHiderController.list_target, Classes::HideCheckedItems

  def window_title
    list.try(&.name).try(&.value)
  end
end
