require "../application_page"
require "../../views/lists/members_view"
require "../../models/list"

module Lists
  class MembersPage < ApplicationPage
    def self.root_path
      "/lists"
    end

    def self.nested_path
      "/members"
    end

    def self.uri_path_matcher
      /^\/lists\/((\d+))\/members(\/)?$/
    end

    layout ApplicationLayout do
      def top_app_bar
        nil
      end
    end

    def page_view
      Lists::MembersView.new(ctx, List.find(id))
    end

    def window_title : String?
      "Teilnehmer"
    end
  end
end
