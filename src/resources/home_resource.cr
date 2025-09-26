class HomeResource < ApplicationResource
  def layout_config(layout)
    super
    layout.window_title = "Grocerlyst"
  end

  def index
    if ctx.request.headers["Referer"]?.nil? && (last_list_id = ctx.session.last_used_list_id) && List.find(last_list_id)
      redirect ListResource.uri_path(last_list_id)
      return
    end

    render HomeView
  end

  def self.root_path
    "/"
  end
end
