class ChangelogResource < ApplicationResource
  layout ApplicationLayout do
    def window_title
      "Changelog"
    end
  end

  def index
    render ChangelogView
  end
end
