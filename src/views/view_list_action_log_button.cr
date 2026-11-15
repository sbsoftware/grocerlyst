class ViewListActionLogButton
  include Crumble::ContextView
  include Crumble::Crababel

  getter list : List

  def initialize(@ctx, @list); end

  ToHtml.instance_template do
    a ListContextMenu::Entry, role: "menuitem", href: Lists::ActionLogPage.uri_path(list_id: list.id) do
      Crumble::Material::Icon.new("history")
      span { t.label }
    end
  end
end
