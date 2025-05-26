require "./application_resource"

class AccessResource < ApplicationResource
  def show
    unless id?
      @ctx.response.status = :bad_request
      return
    end

    unless list = List.where({"access_token" => id}).to_a.first
      @ctx.response.status = :not_found
      return
    end

    if ListAccessPermission.where({"list_id" => list.id, "session_id" => ctx.session.id.to_s}).first?
      redirect ListResource.uri_path(list.id)
    else
      render Lists::AccessView.new(ctx, list)
    end
  end

  def update
    unless id?
      @ctx.response.status = :bad_request
      return
    end

    unless list = List.where({"access_token" => id}).to_a.first
      @ctx.response.status = :not_found
      return
    end

    ListAccessPermission.create(list_id: list.id, session_id: @ctx.session.id.to_s)

    redirect ListResource.uri_path(list.id)
  end

  def self.uri_path_matcher
    /^#{root_path}(\/|\/([a-z0-9]+))$/
  end

  def id?
    self.class.match(@ctx.request.path).try { |m| m[2]? }
  end
end
