require "../js/web_manifest"
require "../js/service_worker_registration"

class ApplicationLayout < Crumble::Material::Layout
  class RootLink
    ToHtml.class_template do
      a href: HomePage.uri_path do
        "Grocerlyst"
      end
    end
  end

  def drawer_headline
    RootLink
  end

  def headline
    "Grocerlyst"
  end

  def window_title
    ctx.handler.window_title || "Grocerlyst"
  end

  append_to_head ApplicationStyle, Lists::CardView::Style, WebManifest
  append_to_head ListAccessPermission::SetNameAction::Template::Style
  append_to_head Crumble::Material::ListItem::Style

  append_to_head ServiceWorkerRegistration

  def drawer_items
    [LegalNoticeMenuItem, DataPrivacyNoticeMenuItem]
  end
end
