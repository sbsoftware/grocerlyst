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
      name: "List from #{Time.local.to_s("%F")}",
      session_id: ctx.session.id.to_s
    )

    ListAccessPermission.create(list_id: new_list.id, session_id: ctx.session.id.to_s)

    redirect ListResource.uri_path(new_list.id)
  end

  def show
    unless list && ctx.list_policy.show?(list)
      redirect HomePage.uri_path
      return
    end

    ctx.session.update!(last_used_list_id: list.id.value)

    render ListView.new(ctx, list)
  end

  def list
    List.find(id)
  end
end
