class ListLayout < ApplicationLayout
  property list : List?

  def body_controllers
    [ListItemSearchController, ListItemHiderController, ListItemHiderController.list_target]
  end

  def window_title
    list.try(&.name).try(&.value)
  end

  def headline
    list.try(&.header_view)
  end

  def contextual_actions
    arr = [ItemHider] of (ItemHider.class | ShareList)

    if (_list = list) && ctx.list_policy.share?(_list)
      arr << ShareList.new(ctx, _list)
    end

    arr
  end
end
