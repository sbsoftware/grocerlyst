class DataPrivacyNoticeResource < ApplicationResource
  layout ApplicationLayout do
    def self.window_title
      "Datenschutz"
    end
  end

  def index
    render DataPrivacyNoticeView
  end
end
