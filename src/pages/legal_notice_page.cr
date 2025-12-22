require "./application_page"
require "../views/legal_notice_view"

class LegalNoticePage < ApplicationPage
  view LegalNoticeView

  def window_title : String?
    "Impressum"
  end
end
