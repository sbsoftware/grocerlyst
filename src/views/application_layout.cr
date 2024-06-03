class ApplicationLayout < Crumble::Material::Layout
  def stylesheets
    [ApplicationStyle, Crumble::TurboStyle]
  end

  def external_scripts
    ["https://unpkg.com/@hotwired/turbo@8.0.4/dist/turbo.es2017-umd.js"]
  end

  def drawer_items
    all_lists_views + legal_menu_items
  end

  def contextual_actions
    [ItemHider]
  end

  def all_lists_views
    List.all.map(&.default_view)
  end

  def legal_menu_items
    [LegalNoticeMenuItem, DataPrivacyNoticeMenuItem, ChangelogMenuItem]
  end
end
