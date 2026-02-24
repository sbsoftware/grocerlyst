require "./application_page"
require "../models/list"
require "../views/list_layout"

class ListPage < ApplicationPage
  model list : List, HomePage.uri_path

  layout ListLayout

  view do
    def list_access_permission
      ListAccessPermission.where(list_id: list.id, session_id: ctx.session.id.to_s).first
    end

    template do
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

  def call
    current_list = list.not_nil!

    unless ctx.list_policy.show?(current_list)
      ctx.response.status_code = 303
      ctx.response.headers["Location"] = HomePage.uri_path
      return
    end

    ctx.session.update!(last_used_list_id: current_list.id.value)
    super
  end
end
