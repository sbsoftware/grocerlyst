class SwitchedClass < CSS::CSSClass
end

class SwitchController < StimulusController
  values :resourceuri, :toggle

  method :switch do
    el = this.element
    fetch(this.resourceuriValue, this.request_method).then do |res|
      res.text().then do |text|
        console.log("response!")
        el.outerHTML = text
      end
    end
    this.toggle_value
  end

  method :request_method do
    if this.toggleValue === "true"
      return Template::Method::Delete
    else
      return Template::Method::Post
    end
  end

  method :toggle_value do
    if this.toggleValue === "true"
      this.toggleValue = "false"
    else
      this.toggleValue = "true"
    end
  end
end
