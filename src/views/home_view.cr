class HomeView
  include Crumble::ContextView

  GroceriesImageFile = PNGImage.register "assets/groceries.png"

  css_class Home
  css_class Container
  css_class Hero
  css_class HeroText
  css_class HeroTitle
  css_class HeroLead
  css_class HeroCta
  css_class PrimaryButton
  css_class HeroImageWrap
  css_class HeroImage
  css_class Features
  css_class Feature
  css_class FeatureIcon
  css_class FeatureText
  css_class FeatureTitle
  css_class FeatureBody
  css_class ListsSection
  css_class Lists
  css_class List
  css_class NewListCard

  style do
    rule Home do
      background_color "#F7FAF6"
      padding_top 32.px
      padding_bottom 40.px
    end

    rule Container do
      max_width 1100.px
      margin_left :auto
      margin_right :auto
      padding_left 24.px
      padding_right 24.px
      box_sizing :border_box
    end

    rule Hero do
      display :grid
      property("grid-template-columns", "repeat(auto-fit, minmax(min(380px, 100%), 1fr))")
      gap 32.px
      align_items :center
      margin_bottom 28.px
    end

    rule HeroTitle do
      font_size 48.px
      font_weight 800
      margin 0
      property("letter-spacing", "-0.02em")
      line_height 1.05
    end

    rule HeroLead do
      font_size 18.px
      color "#2F3A2F"
      margin_top 12.px
      margin_bottom 16.px
      max_width 36.rem
      line_height 1.4
    end

    rule HeroCta do
      margin_top 8.px

      rule "button" do
        border :none
        cursor :pointer
      end
    end

    rule PrimaryButton do
      background_color "#2E7D32"
      color :white
      padding_top 10.px
      padding_bottom 10.px
      padding_left 16.px
      padding_right 16.px
      border_radius 8.px
      font_size 16.px
      font_weight 600
      box_shadow 0.px, 2.px, 10.px, rgb(46, 125, 50, alpha: 0.25)
    end

    rule HeroImageWrap do
      display :flex
      justify_content :flex_end
      align_items :center
    end

    rule HeroImage do
      width 100.percent
      max_width 620.px
      border_radius 14.px
      box_shadow 0.px, 8.px, 20.px, rgb(0, 0, 0, alpha: 0.08)
      aspect_ratio ratio(16, 9)
      property("object-fit", "cover")
      background_color "#E9EFE6"
    end

    rule Features do
      display :grid
      property("grid-template-columns", "repeat(auto-fit, minmax(220px, 1fr))")
      gap 22.px
      margin_bottom 26.px
    end

    rule Feature do
      display :grid
      property("grid-template-columns", "40px 1fr")
      gap 12.px
      align_items :start
    end

    rule FeatureIcon do
      width 36.px
      height 36.px
      border_radius 999.px
      background_color "#2E7D32"
      display :flex
      align_items :center
      justify_content :center

      rule Crumble::Material::Icon::IconClass do
        color :white
      end
    end

    rule FeatureTitle do
      font_weight 700
      margin 0
      margin_bottom 2.px
    end

    rule FeatureBody do
      color "#4D5A4D"
      font_size 14.px
      margin 0
      line_height 1.35
    end

    rule ListsSection do
      background_color :white
      border_radius 18.px
      box_shadow 0.px, 8.px, 22.px, rgb(0, 0, 0, alpha: 0.07)
      padding 22.px
    end

    rule Lists do
      list_style :none
      padding 0
      margin 0
      display :grid
      property("grid-template-columns", "repeat(auto-fit, minmax(220px, 1fr))")
      gap 16.px
    end

    rule ListsSection do
      rule Crumble::Material::Card::Card do
        width 100.percent
        max_width 100.percent
        min_height 110.px
        margin_bottom 0.px
        box_shadow 0.px, 2.px, 12.px, rgb(0, 0, 0, alpha: 0.06)
        border_radius 14.px
      end
    end

    rule NewListCard do
      rule Crumble::Material::Card::Card do
        padding 0.px
        box_shadow :none
        border_radius 14.px
        min_height 110.px
        height 100.percent
      end

      rule form do
        height 100.percent
      end

      rule button do
        border 2.px
        border_style :solid
        border_color :black
        background_color :transparent
        width 100.percent
        height 100.percent
        display :flex
        justify_content :center
        align_items :center
        flex_direction :column
        font_size 16.px
        cursor :pointer
        border_radius 14.px
        color :black
        font_weight 700
        gap 8.px

        rule Crumble::Material::Icon::IconClass do
          font_size 28.px
        end
      end
    end

    media "max-width: 900px" do
      rule Container do
        padding_left 16.px
        padding_right 16.px
      end

      rule Hero do
        property("grid-template-columns", "1fr")
        gap 16.px
        margin_bottom 20.px
      end

      rule HeroTitle do
        font_size 34.px
      end

      rule HeroImageWrap do
        justify_content :flex_start
      end

      rule HeroImage do
        max_width 520.px
      end

      rule Features do
        property("grid-template-columns", "1fr")
        gap 14.px
      end
    end
  end

  template do
    div Home do
      div Container do
        div Hero do
          div HeroText do
            h1 HeroTitle do
              "Collaborative Shopping"
            end
            p HeroLead do
              "Are You A Grocerlyst?"
            end
            form HeroCta, action: ListResource.uri_path, method: "POST" do
              button PrimaryButton, type: "submit" do
                "Get Started"
              end
            end
          end
          div HeroImageWrap do
            img HeroImage, src: GroceriesImageFile.uri_path, alt: "Lebensmittel"
          end
        end

        div Features do
          div Feature do
            div FeatureIcon do
              Crumble::Material::Icon.new("check_circle")
            end
            div FeatureText do
              p FeatureTitle do
                "Easy to use"
              end
              p FeatureBody do
                "Quickly add, edit and organize your items"
              end
            end
          end

          div Feature do
            div FeatureIcon do
              Crumble::Material::Icon.new("group")
            end
            div FeatureText do
              p FeatureTitle do
                "Share your list"
              end
              p FeatureBody do
                "Work together with family and friends"
              end
            end
          end

          div Feature do
            div FeatureIcon do
              Crumble::Material::Icon.new("smartphone")
            end
            div FeatureText do
              p FeatureTitle do
                "Access anywhere"
              end
              p FeatureBody do
                "Available on any device, anywhere"
              end
            end
          end

          div Feature do
            div FeatureIcon do
              Crumble::Material::Icon.new("cable")
            end
            div FeatureText do
              p FeatureTitle do
                "Real-time"
              end
              p FeatureBody do
                "See what others have added instantly"
              end
            end
          end
        end

        div ListsSection do
          ul Lists do
            ctx.list_policy.accessible_lists.each do |list|
              li List do
                list.card_view.renderer(ctx)
              end
            end
            li NewListCard do
              Crumble::Material::Card.new.to_html do
                form action: ListResource.uri_path, method: "POST" do
                  button do
                    Crumble::Material::Icon.new("add_circle")
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
