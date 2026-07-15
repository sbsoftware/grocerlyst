class LocalTimeController < Stimulus::Controller
  js_method :connect do
    value = this.element.getAttribute("datetime")
    return nil unless value

    date = Date.new(value)
    return nil if Number.isNaN(date.getTime._call)

    this.element.textContent = Intl.DateTimeFormat.new(nil, {dateStyle: "medium", timeStyle: "short", hour12: false}).format(date)
  end
end
