require "../application_page"
require "../../views/lists/members_view"
require "../../models/list"

module Lists
  class MembersPage < ApplicationPage
    root_path "/lists"
    model list : List
    nested_path "/members"

    layout ApplicationLayout do
      def top_app_bar
        nil
      end
    end

    def page_view
      Lists::MembersView.new(ctx, List.find(id))
    end

    def window_title : String?
      "Members"
    end
  end
end
