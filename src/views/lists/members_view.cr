module Lists
  class MembersView
    include Crumble::ContextView

    getter list : List

    def initialize(@ctx, @list); end

    class BackLink
      getter list : List

      def initialize(@list); end

      ToHtml.instance_template do
        a href: ListResource.uri_path(list.id) do
          Crumble::Material::Icon.new("arrow_back")
        end
      end
    end

    css_class Member

    ToHtml.instance_template do
      Crumble::Material::TopAppBar.new(
        leading_icon: BackLink.new(list),
        headline: "Teilnehmer",
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
                  "Anonym"
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
end
