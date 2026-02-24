require "../application_page"
require "../../models/list"
require "../list_page"

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

    view do
      class BackLink
        getter list : List

        def initialize(@list); end

        ToHtml.instance_template do
          a href: ListPage.uri_path(list_id: list.id) do
            Crumble::Material::Icon.new("arrow_back")
          end
        end
      end

      css_class Member

      template do
        Crumble::Material::TopAppBar.new(
          leading_icon: BackLink.new(list),
          headline: "Members",
          trailing_icons: [] of Nil,
          type: :center_aligned
        )
        div do
          list.list_access_permissions.each do |list_access_permission|
            Crumble::Material::ListItem.to_html do
              div Member do
                Crumble::Material::Icon.new("account_circle")
                if name = list_access_permission.name
                  name
                else
                  i do
                    "Anonymous"
                  end
                end
              end
            end
          end
        end
      end

      style do
        rule Member do
          display :flex
          gap 8.px
        end
      end
    end

    def window_title : String?
      "Members"
    end
  end
end
