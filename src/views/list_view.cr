class ListView
  include Crumble::ContextView

  getter list : List

  def initialize(@ctx, @list); end

  class BackLink
    ToHtml.class_template do
      a HomePage do
        Crumble::Material::Icon.new("arrow_back")
      end
    end
  end

  def list_access_permission
    ListAccessPermission.where(list_id: list.id, session_id: ctx.session.id.to_s).first
  end

  private def top_app_bar
    Crumble::Material::TopAppBar.new(
      leading_icon: BackLink,
      headline: list.header_view.renderer(ctx),
      trailing_icons: contextual_actions,
      type: :small
    )
  end

  private def contextual_actions
    arr = [AddModeButton, ItemHider] of (AddModeButton.class | ItemHider.class | ShareList | ViewListMembersButton)

    if ctx.list_policy.share?(list)
      arr << ShareList.new(ctx, list)
    end
    arr << ViewListMembersButton.new(list)

    arr
  end

  ToHtml.instance_template do
    top_app_bar
    list_access_permission.set_name_form.renderer(ctx) if list.list_access_permissions.count > 1
    list.set_name_action_template(ctx)
    div ListItemSearchController.addDisplayContainer_target, Classes::AddItemDisplayHidden, ListItem.active(false) do
      Crumble::Material::ListItem.to_html do
        li Classes::ListItem do
          div Classes::AddItemForm do
            list.add_item_action_template(ctx).to_html
            span ListItemSearchController.add_action("click") do
              Crumble::Material::Icon.new("add_circle")
            end
            span ListItemSearchController.disable_search_mode_action("click") do
              Crumble::Material::Icon.new("cancel")
            end
          end
        end
      end
    end
    list.items_view.renderer(ctx)
  end
end
