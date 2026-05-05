class ListPolicy
  getter ctx : Crumble::Server::RequestContext

  def initialize(@ctx); end

  def show?(list : List)
    owns?(list) || has_access?(list)
  end

  def share?(list : List)
    owns?(list) || has_access?(list)
  end

  def accessible_lists
    ListAccessPermission.where(session_id: ctx.session.id.to_s).to_a.map(&.list)
  end

  private def owns?(list : List)
    list.session_id == ctx.session.id.to_s
  end

  private def has_access?(list : List)
    list.list_access_permissions.to_a.any? do |list_access_permission|
      list_access_permission.session_id == ctx.session.id.to_s
    end
  end
end
