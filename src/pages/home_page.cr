require "./application_page"
require "../views/home_view"
require "../models/list"
require "../resources/list_resource"

class HomePage < ApplicationPage
  view HomeView

  def self.root_path
    "/"
  end

  def window_title : String?
    "Grocerlyst"
  end

  def call
    if ctx.request.headers["Referer"]?.nil? && (last_list_id = ctx.session.last_used_list_id) && List.find(last_list_id)
      ctx.response.status_code = 303
      ctx.response.headers["Location"] = ListResource.uri_path(last_list_id)
      return
    end

    super
  end
end
