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
    [ApplicationStyle, HomeView::Style, Crumble::Material::Card::Style, Crumble::Material::Card::Title::Style, Crumble::Material::Card::SecondaryText::Style, Lists::CardView::Style, Crumble::TurboStyle, ReorderItemsAction::Template::Style, DeleteRecordAction::Template::Style, WebManifest]
  end

  def external_scripts
    ["https://unpkg.com/@hotwired/turbo@8.0.4/dist/turbo.es2017-umd.js"]
  end

  def inline_scripts
    [ServiceWorkerRegistration.to_js]
  end

  def drawer_items
    [LegalNoticeMenuItem, DataPrivacyNoticeMenuItem, ChangelogMenuItem]
  end
end
