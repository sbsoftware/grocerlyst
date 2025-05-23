require "../../views/lists/members_view"

module Lists
  class MembersResource < Crumble::Resource
    def self.root_path
      "/lists"
    end

    def self.nested_path
      "/members"
    end

    layout ApplicationLayout do
      def top_app_bar
        nil
      end
    end

    def index
      list = List.find(id)

      render Lists::MembersView.new(ctx, list)
    end
  end
end
