class ApplicationResource < Resource
  def layout_class
    Crumble::Material::Layout
  end

  def layout_config(layout)
    layout.stylesheets << ApplicationStyle
    layout.stylesheets << Crumble::TurboStyle
    layout.scripts << TurboJS
    layout.drawer_items = all_lists_views + legal_menu_items
  end

  def all_lists_views
    List.all.map(&.default_view).map { |lv| lv.as(String | Template) }
  end

  def legal_menu_items
    [LegalNoticeMenuItem.new, DataPrivacyNoticeMenuItem.new, ChangelogMenuItem.new].map { |mi| mi.to_s.as(String | Template) }
  end
end
