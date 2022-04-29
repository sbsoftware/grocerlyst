class ListItemSwitchResource < Resource
  def create
    li = list_item
    li.active = true
    li.save

    render li.default_view
  end

  def destroy
    li = list_item
    li.active = false
    li.save

    render li.default_view
  end

  def list_item
    ListItem.find(id)
  end

  def self.root_path
    "/list_item"
  end

  def self.nested_path
    "/switch"
  end
end
