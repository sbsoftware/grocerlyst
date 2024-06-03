class LegalNoticeResource < ApplicationResource
  layout ApplicationLayout do
    def self.window_title
      "Impressum"
    end
  end

  def index
    render LegalNoticeView
  end
end
