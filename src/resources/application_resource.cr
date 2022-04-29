class ApplicationResource < Resource
  def layout_class
    Crumble::Material::Layout
  end

  def layout_config(layout)
    layout.stylesheets << ApplicationStyle
    # layout.scripts << ServiceWorkerRegister.to_s
    layout.drawer_items = all_lists_views
  end

  def all_lists_views
    List.all.map(&.default_view).map { |lv| lv.as(String | Template) }
  end
end
