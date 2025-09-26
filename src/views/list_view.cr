class ListView
  include Crumble::ContextView

  getter list : List

  def initialize(@ctx, @list); end

  def list_access_permission
    ListAccessPermission.where({"list_id" => list.id, "session_id" => ctx.session.id.to_s}).first
  end

  ToHtml.instance_template do
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
