class ChangelogResource < ApplicationResource
  def layout_config(layout)
    super
    layout.window_title = "Changelog"
  end

  def index
    render ChangelogView.new
  end
end
