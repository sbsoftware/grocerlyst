class HomeResource < ApplicationResource
  def layout_config(layout)
    super
    layout.window_title = "Einkaufsliste"
  end

  def index
    lists = List.all
    render ListsView.new(lists.to_a)
  end

  def self.root_path
    "/"
  end
end
