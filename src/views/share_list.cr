class ShareList
  include Crumble::ContextView
  include Crumble::Crababel

  getter list : List

  def initialize(@ctx, @list); end

  ToHtml.instance_template do
    list.share_element.to_html do
      button ListContextMenu::Entry, type: "button", role: "menuitem" do
        Crumble::Material::Icon.new("share")
        span { t.label }
      end
    end
  end
end
