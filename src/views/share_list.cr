class ShareList
  include Crumble::ContextView

  getter list : List

  def initialize(@ctx, @list); end

  ToHtml.instance_template do
    list.share_element.to_html do
      Crumble::Material::Icon.new("share")
    end
  end
end
