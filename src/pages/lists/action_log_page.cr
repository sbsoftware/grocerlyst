require "../application_page"
require "../../models/list"
require "../list_page"

module Lists
  class ActionLogPage < ApplicationPage
    root_path "/lists"
    model list : List
    nested_path "/action-log"

    css_class Page
    css_class Empty

    style do
      rule Page do
        padding 16.px

        rule ".list-action-events" do
          display :block
        end

        rule ".list-action-event-row" do
          margin_bottom 12.px
        end

        rule Crumble::Material::Card::Card do
          width 100.percent
          max_width 100.percent
          min_height 0.px
          margin_bottom 0.px
          box_shadow 0.px, 2.px, 12.px, rgb(0, 0, 0, alpha: 0.08)
          border_radius 8.px
        end

        rule ".list-action-event-main" do
          line_height 1.4
        end

        rule ".list-action-event-actor" do
          font_weight 600
        end

        rule ".list-action-event-time" do
          display :block
          color "#666666"
          font_size 14.px
          margin_top 8.px
        end
      end

      rule Empty do
        margin 0
      end
    end

    layout ApplicationLayout do
      def top_app_bar
        nil
      end
    end

    class BackLink
      getter list : List

      def initialize(@list); end

      ToHtml.instance_template do
        a href: ListPage.uri_path(list_id: list.id) do
          Crumble::Material::Icon.new("arrow_back")
        end
      end
    end

    template do
      Crumble::Material::TopAppBar.new(
        leading_icon: BackLink.new(list),
        headline: "Action log",
        trailing_icons: [] of Nil,
        type: :center_aligned
      )
      div Page do
        if list.action_events.to_a.empty?
          p Empty do
            "No actions yet."
          end
        else
          list.action_log_view.renderer(ctx)
        end
      end
    end

    before do
      unless ctx.list_policy.show?(list)
        ctx.response.status_code = 303
        ctx.response.headers["Location"] = HomePage.uri_path
        return 303
      end

      true
    end

    def window_title : String?
      "Action log"
    end
  end
end
