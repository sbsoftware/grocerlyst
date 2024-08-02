class DeleteActionController < Stimulus::Controller
  targets :submit

  action :delete do |event|
    event.preventDefault._call
    event.stopPropagation._call

    if window.confirm("Wirklich löschen?")
      this.submitTarget.click._call
    end
  end
end
