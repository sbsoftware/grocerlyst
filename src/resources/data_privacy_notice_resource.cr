class DataPrivacyNoticeResource < ApplicationResource
  def layout_config(layout)
    super
    layout.window_title = "Datenschutz"
  end

  def index
    render DataPrivacyNoticeView.new
  end
end
