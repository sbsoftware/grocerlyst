class ListItemPolicy
  getter ctx : Crumble::Server::HandlerContext

  def initialize(@ctx); end

  def delete?(list_item)
    owns_list?(list_item) || list_access_permission?(list_item)
  end

  private def owns_list?(list_item)
    list_item.list.session_id == ctx.session.id.to_s
  end

  private def list_access_permission?(list_item)
    list_item.list.list_access_permissions.any? do |list_access_permission|
      list_access_permission.session_id == ctx.session.id.to_s
    end
  end
end
