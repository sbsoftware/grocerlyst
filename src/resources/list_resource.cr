class ListResource < ApplicationResource
  layout ListLayout

  def resource_layout
    layout = previous_def
    layout.list = list
    layout
  end

  def create
    new_list = List.new
    new_list.name = Time.local.to_s("%F")
    new_list.save

    redirect ListResource.uri_path(new_list.id)
  end

  def show
    render list.items_view
  end

  def list
    List.find(id)
  end
end
