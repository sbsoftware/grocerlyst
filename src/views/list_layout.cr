class ListLayout < ApplicationLayout
  property list : List?

  def body_controllers
    super + [ListItemSearchController, ListItemSearchController.list_item_hider_controller_outlet("body"), ListItemHiderController, ListItemHiderController.list_target, Classes::HideCheckedItems]
  end

  def window_title
    list.try(&.name).try(&.value)
  end

  class BackLink
    ToHtml.class_template do
      a HomeResource, Crumble::Material::Classes::MaterialIcon do
        "arrow_back"
      end
    end
  end

  def top_app_bar
    Crumble::Material::TopAppBar.new(
      leading_icon: BackLink,
      headline: headline,
      trailing_icons: contextual_actions || [] of Nil,
      type: :small
    )
  end

  def headline
    list.try(&.name)
  end

  def contextual_actions
    arr = [AddModeButton, ItemHider] of (AddModeButton.class | ItemHider.class | ShareList)

    if (_list = list) && ctx.list_policy.share?(_list)
      arr << ShareList.new(ctx, _list)
    end

    arr
  end
end
