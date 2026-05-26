class PushSubscriptionBanner
  include Crumble::ContextView

  css_class Banner
  css_class Content

  template do
    div Banner do
      div Content do
        span do
          "Get notifications when your lists change."
        end
        button CrumbleWebPush::SubscriptionController.subscribe_action("click"), type: "button" do
          "Subscribe"
        end
      end
    end
  end

  style do
    rule Banner do
      width 100.percent
      box_sizing :border_box
      padding 10.px, 16.px
      background_color "#EAF6EF"
      border_bottom 1.px, :solid, "#B7DCC5"
      color "#183B25"
    end

    rule Content do
      display :flex
      justify_content :space_between
      align_items :center
      gap 12.px
      max_width 720.px
      margin 0, :auto

      rule "button" do
        flex_shrink 0
        border 0
        border_radius 4.px
        padding 8.px, 12.px
        background_color "#2F6D45"
        color :white
        font_weight 600
      end
    end
  end
end
