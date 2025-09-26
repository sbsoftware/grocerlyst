class HomeView
  include Crumble::ContextView

  css_class Lists
  css_class List
  css_class NewListCard
  css_class ButtonText

  style do
    rule Lists do
      listStyle None
      padding 0
      margin 0
      display Flex
      flexWrap Wrap
    end

    rule Lists > li do
      marginLeft 16.px
      marginRight 16.px
      marginBottom 16.px
    end

    media "max-width: 815px" do
      rule Lists do
        justifyContent SpaceEvenly
      end
    end

    rule NewListCard >> form do
      height 100.percent
    end

    rule NewListCard >> button do
      prop("border", "0")
      prop("background-color", "transparent")
      width 100.percent
      height 100.percent
      display Flex
      justifyContent Center
      alignItems Center
      fontFamily "Roboto, sans serif"
      fontSize 16.px
      prop("cursor", "pointer")
    end

    rule ButtonText do
      marginLeft 2.px
    end
  end

  template do
    ul Lists do
      ctx.list_policy.accessible_lists.each do |list|
        li do
          list.card_view.renderer(ctx)
        end
      end
      li NewListCard do
        Crumble::Material::Card.new.to_html do
          form action: ListResource.uri_path, method: "POST" do
            button do
              Crumble::Material::Icon.new("add_circle")
              span ButtonText do
                "Neue Liste"
              end
            end
          end
        end
      end
    end
  end
end
