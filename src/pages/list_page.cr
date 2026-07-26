require "./application_page"
require "../models/list"
require "../push_notifications"
require "../views/list_layout"
require "../views/push_subscription_banner"

class ListPage < ApplicationPage
  model list : List, HomePage.uri_path

  layout ListLayout

  class BackLink
    ToHtml.class_template do
      a href: HomePage.uri_path do
        Crumble::Material::Icon.new("arrow_back")
      end
    end
  end

  def list_access_permission
    ListAccessPermission.where(list_id: list.id, session_id: ctx.session.id.to_s).first
  end

  def top_app_bar
    Crumble::Material::TopAppBar.new(
      leading_icon: BackLink,
      headline: list.header_view.renderer(ctx),
      trailing_icons: [
        ItemHider,
        ShareList.new(ctx: ctx, list: list),
        ViewListActionLogButton.new(list),
        ViewListMembersButton.new(list),
      ],
      type: :small
    )
  end

  template do
    top_app_bar
    list.set_name_action_template(ctx)
    PushSubscriptionBanner.new(ctx: ctx).to_html unless PushNotifications.subscribed?(ctx.session.id.to_s)
    list_access_permission.set_name_form.renderer(ctx) if list.list_access_permissions.count > 1
    AddModeButton.new("top")
    AddItemForm.new(list, "top")
    list.items_view.renderer(ctx)
    AddItemForm.new(list, "bottom")
    AddModeButton.new("bottom")
  end

  before do
    current_list = list.not_nil!

    unless ctx.list_policy.show?(current_list)
      ctx.response.status_code = 303
      ctx.response.headers["Location"] = HomePage.uri_path
      return 303
    end

    ctx.session.update!(last_used_list_id: current_list.id.value)
    true
  end
end
