class ShareList < Crumble::ContextView
  getter list : List

  def initialize(@ctx, @list); end

  ToHtml.instance_template do
    if token = list.access_token
      a Crumble::Material::Classes::MaterialIcon, ShareController, ShareController.share_action("click"), ShareController.url_value("https://#{ctx.request.hostname}#{ListAccessPermissionResource.uri_path(token.value)}") do
        "share"
      end
    end
  end
end
