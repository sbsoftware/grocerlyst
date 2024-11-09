require "../material/card"
require "../material/card_title"
require "../material/card_secondary_text"

class Lists::CardView
  getter list : List

  def initialize(@list); end

  css_class Attribute

  style do
    rule Attribute do
      display InlineBlock
      marginRight 8.px
    end

    rule Attribute > span do
      prop("vertical-align", "middle")
      display InlineBlock
    end

    rule Attribute > Crumble::Material::Classes::MaterialIcon do
      marginRight 2.px
    end
  end

  ToHtml.instance_template do
    Crumble::Material::Card.new(link_target: ListResource.uri_path(list.id)).to_html do
      Crumble::Material::Card::Title.new(list.name)
      Crumble::Material::Card::SecondaryText.new.to_html do
        div Attribute do
          span Crumble::Material::Classes::MaterialIcon do
            "list"
          end
          span do
            list.list_items.count
            " Elemente"
          end
        end
        div Attribute do
          span Crumble::Material::Classes::MaterialIcon do
            "account_circle"
          end
          span do
            list.list_access_permissions.count + 1
            " Teilnehmer"
          end
        end
      end
    end
  end
end
