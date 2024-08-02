class ListItemPolicy
  getter ctx : Crumble::Server::RequestContext

  def initialize(@ctx); end

  def delete?(list_item)
    list_item.list.session_id.value == ctx.session.id.to_s
  end
end
