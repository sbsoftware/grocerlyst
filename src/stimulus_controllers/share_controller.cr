class ShareController < Stimulus::Controller
  values url: String

  action :share do |event|
    event.preventDefault._call

    if navigator.share
      navigator.share({text: this.urlValue})
    else
      window.alert("Teilen auf diesem Gerät leider nicht möglich!")
    end
  end
end
