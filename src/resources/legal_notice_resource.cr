class LegalNoticeResource < ApplicationResource
  def layout_config(layout)
    super
    layout.window_title = "Impressum"
  end

  def index
    render LegalNoticeView.new
  end
end
