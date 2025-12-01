class HomeView
  include Crumble::ContextView

  css_class Lists
  css_class List
  css_class NewListCard
  css_class ButtonText

  style do
    rule Lists do
      list_style :none
      padding 0
      margin 0
      display :flex
      flex_wrap :wrap
    end

    rule Lists > li do
      margin_left 16.px
      margin_right 16.px
      margin_bottom 16.px
    end

    media "max-width: 815px" do
      rule Lists do
        justify_content :space_evenly
      end
    end

    rule NewListCard do
      rule form do
        height 68.px
      end

      rule button do
        border :none
        background_color :transparent
        width 100.percent
        height 100.percent
        display :flex
        justify_content :center
        align_items :center
        font_family "Roboto, sans serif"
        font_size 16.px
        cursor :pointer
      end
    end

    rule ButtonText do
      margin_left 2.px
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
