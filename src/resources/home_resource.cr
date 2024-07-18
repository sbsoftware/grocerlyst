class HomeResource < ApplicationResource
  def layout_config(layout)
    super
    layout.window_title = "Einkaufsliste"
  end

  def index
    render HomeView
  end

  def self.root_path
    "/"
  end
end
