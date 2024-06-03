class Lists::MenuItem
  getter list : List

  def initialize(@list); end

  ToHtml.instance_template do
    a href: ListResource.uri_path(list.id) do
      list.name
    end
  end
end
