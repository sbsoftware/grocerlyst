class ViewListActionLogButton
  getter list : List

  def initialize(@list); end

  ToHtml.instance_template do
    a href: Lists::ActionLogPage.uri_path(list_id: list.id) do
      Crumble::Material::Icon.new("history")
    end
  end
end
