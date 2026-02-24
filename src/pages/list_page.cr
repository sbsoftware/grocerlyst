require "./application_page"
require "../models/list"
require "../views/list_view"
require "../views/list_layout"

class ListPage < ApplicationPage
  model list : List, HomePage.uri_path

  layout ListLayout

  # Keep parity with the old resource: non-accessible lists always bounce back home.
  before do
    current_list = list.not_nil!

    unless ctx.list_policy.show?(current_list)
      ctx.response.status_code = 303
      ctx.response.headers["Location"] = HomePage.uri_path
      return 303
    end

    ctx.session.update!(last_used_list_id: current_list.id.value)
    true
  end

  def page_view
    ListView.new(ctx, list.not_nil!)
  end
end
