require "../resources/lists/members_resource"

class ViewListMembersButton
  getter list : List

  def initialize(@list); end

  ToHtml.instance_template do
    a href: Lists::MembersResource.uri_path(list.id) do
      Crumble::Material::Icon.new("account_circle")
    end
  end
end
