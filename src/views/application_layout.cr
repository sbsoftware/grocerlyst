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

  append_to_head ApplicationStyle, HomeView::Style, Lists::CardView::Style, WebManifest

  append_to_head ServiceWorkerRegistration

  def drawer_items
    [LegalNoticeMenuItem, DataPrivacyNoticeMenuItem]
  end
end
