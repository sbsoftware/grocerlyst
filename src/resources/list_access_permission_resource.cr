class ListAccessPermissionResource < ApplicationResource
  def show
    unless id?
      @ctx.response.status = :bad_request
      return
    end

    unless list = List.where({"access_token" => id}).to_a.first
      @ctx.response.status = :not_found
      return
    end

    list_access_permission = ListAccessPermission.new
    list_access_permission.list_id = list.id
    list_access_permission.session_id = @ctx.session.id.to_s
    list_access_permission.save

    redirect ListResource.uri_path(list.id)
  end

  def self.uri_path_matcher
    /^#{root_path}(\/|\/([a-z0-9]+))$/
  end

  def id?
    self.class.match(@ctx.request.path).try { |m| m[2]? }
  end
end
