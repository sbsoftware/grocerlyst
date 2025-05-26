class ShareList
  include Crumble::ContextView

  getter list : List

  def initialize(@ctx, @list); end

  ToHtml.instance_template do
    if token = list.access_token
      a ShareController, ShareController.share_action("click"), ShareController.url_value("https://#{ctx.request.hostname}#{AccessResource.uri_path(token.value)}") do
        Crumble::Material::Icon.new("share")
      end
    end
  end
end
