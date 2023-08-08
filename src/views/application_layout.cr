class ApplicationLayout < Crumble::Material::Layout
  def stylesheets
    [ApplicationStyle, Crumble::TurboStyle]
  end

  def scripts
    [TurboJS]
  end

  def stimulus_includes
    StimulusInclude
  end

  def drawer_items
    all_lists_views + legal_menu_items
  end

  def all_lists_views
    List.all.map(&.default_view)
  end

  def legal_menu_items
    [LegalNoticeMenuItem.new, DataPrivacyNoticeMenuItem.new, ChangelogMenuItem.new]
  end
end
