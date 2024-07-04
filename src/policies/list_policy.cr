class ListPolicy
  getter ctx : Crumble::Server::RequestContext

  def initialize(@ctx); end

  def show?(list)
    list.session_id.value == ctx.session.id.to_s
  end

  def accessible_lists
    List.where({"session_id" => ctx.session.id.to_s})
  end
end
