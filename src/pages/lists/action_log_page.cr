require "../application_page"
require "../../models/list"
require "../list_page"

module Lists
  class ActionLogPage < ApplicationPage
    root_path "/lists"
    model list : List
    nested_path "/action-log"

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
      div class: "list-action-log-page" do
        if list.action_events.to_a.empty?
          p class: "list-action-log-empty" do
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
