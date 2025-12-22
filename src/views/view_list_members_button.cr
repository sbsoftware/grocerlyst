class ViewListMembersButton
  getter list : List

  def initialize(@list); end

  ToHtml.instance_template do
    a href: Lists::MembersPage.uri_path(list.id) do
      Crumble::Material::Icon.new("group")
    end
  end
end
