require "./application_page"
require "../views/data_privacy_notice_view"

class DataPrivacyNoticePage < ApplicationPage
  view DataPrivacyNoticeView

  def window_title : String?
    "Privacy policy"
  end
end
