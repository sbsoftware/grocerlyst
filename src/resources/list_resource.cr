require "../views/list_view"

class ListResource < ApplicationResource
  layout ListLayout

  def resource_layout
    layout = previous_def
    layout.list = list
    layout
  end

  def create
    new_list = List.create(
      name: "Liste vom #{Time.local.to_s("%F")}",
      session_id: ctx.session.id.to_s,
      access_token: Random.new.hex
    )

    ListAccessPermission.create(list_id: new_list.id, session_id: ctx.session.id.to_s)

    redirect ListResource.uri_path(new_list.id)
  end

  def show
    unless list && @ctx.list_policy.show?(list)
      redirect HomeResource.uri_path
      return
    end

    if list_id = list.id
      @ctx.session.update!(last_used_list_id: list_id.value)
    end

    render ListView.new(ctx, list)
  end

  def list
    List.find(id)
  end
end
