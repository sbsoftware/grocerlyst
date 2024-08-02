require "../js/web_manifest"
require "../js/service_worker_registration"

class ApplicationLayout < Crumble::Material::Layout
  class RootLink
    ToHtml.class_template do
      a href: HomeResource.uri_path do
        "Einkaufsliste"
      end
    end
  end

  def drawer_headline
    RootLink
  end

  def headline
    "Einkaufsliste"
  end

  def stylesheets
    [ApplicationStyle, Crumble::TurboStyle, ReorderItemsAction::Form::Style, Lists::HeaderView::Style, DeleteRecordAction::Form::Style, WebManifest]
  end

  def external_scripts
    ["https://unpkg.com/@hotwired/turbo@8.0.4/dist/turbo.es2017-umd.js"]
  end

  def inline_scripts
    [ServiceWorkerRegistration.to_js]
  end

  def drawer_items
    all_lists_views + [NewListMenuItem] + legal_menu_items
  end

  def all_lists_views
    ctx.list_policy.accessible_lists.map(&.default_view)
  end

  def legal_menu_items
    [LegalNoticeMenuItem, DataPrivacyNoticeMenuItem, ChangelogMenuItem]
  end
end
