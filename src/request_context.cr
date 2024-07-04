class Crumble::Server::RequestContext
  def session_store
    FileSessionStore.new("tmp/sessions")
  end

  def list_policy
    ListPolicy.new(self)
  end
end
