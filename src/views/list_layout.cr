class ListLayout < ApplicationLayout
  property list : List?

  body_attributes ListItemSearchController, ListItemSearchController.list_item_hider_controller_outlet("body"), ListItemHiderController, ListItemHiderController.list_target, Classes::HideCheckedItems

  def window_title
    list.try(&.name).try(&.value)
  end

  class BackLink
    ToHtml.class_template do
      a HomeResource do
        Crumble::Material::Icon.new("arrow_back")
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
    list.try(&.header_view.renderer(ctx))
  end

  def contextual_actions
    arr = [AddModeButton, ItemHider] of (AddModeButton.class | ItemHider.class | ShareList | ViewListMembersButton)

    if (_list = list)
      if ctx.list_policy.share?(_list)
        arr << ShareList.new(ctx, _list)
      end
      arr << ViewListMembersButton.new(_list)
    end

    arr
  end
end
