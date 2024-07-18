class ListPolicy
  getter ctx : Crumble::Server::RequestContext

  def initialize(@ctx); end

  def show?(list)
    return true if owns?(list)

    list.list_access_permissions.to_a.any? do |list_access_permission|
      list_access_permission.session_id.value == ctx.session.id.to_s
    end
  end

  def share?(list)
    owns?(list)
  end

  def accessible_lists
    List.where({"session_id" => ctx.session.id.to_s})
  end

  private def owns?(list)
    list.session_id.value == ctx.session.id.to_s
  end
end
