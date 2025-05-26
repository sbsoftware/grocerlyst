class ListView
  include Crumble::ContextView

  getter list : List

  def initialize(@ctx, @list); end

  def list_access_permission
    ListAccessPermission.where({"list_id" => list.id, "session_id" => ctx.session.id.to_s}).first
  end

  ToHtml.instance_template do
    list_access_permission.set_name_form if list.list_access_permissions.count > 1
    list.set_name_action_template
    list.items_view
  end
end
