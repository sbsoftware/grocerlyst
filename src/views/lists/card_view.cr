class Lists::CardView
  getter list : List

  def initialize(@list); end

  css_class Attribute

  style do
    rule Attribute do
      display :inline_block
      margin_right 8.px
    end
  end

  ToHtml.instance_template do
    Crumble::Material::Card.new(link_target: ListPage.uri_path(list.id)).to_html do
      Crumble::Material::Card::Title.new(list.name)
      Crumble::Material::Card::SecondaryText.new.to_html do
        div Attribute do
          Crumble::Material::Icon.new("list", "#{list.list_items.count} Items")
        end
        div Attribute do
          Crumble::Material::Icon.new("account_circle", "#{list.list_access_permissions.count} Members")
        end
      end
    end
  end
end
