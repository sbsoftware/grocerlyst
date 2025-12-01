module Lists
  class AccessView
    include Crumble::ContextView

    getter list : List

    def initialize(@ctx, @list); end

    css_class Container

    ToHtml.instance_template do
      div Container do
        h1 do
          "Du wurdest eingeladen, an der Liste &quot;#{list.name}&quot; teilzunehmen!"
        end
        if token = list.access_token
          form action: AccessResource.uri_path(token.value), method: "POST" do
            button do
              "Teilnehmen"
            end
          end
        end
      end
    end

    style do
      rule Container do
        display :flex
        flex_direction :column
        align_items :center
        padding 16.px
      end
    end
  end
end
