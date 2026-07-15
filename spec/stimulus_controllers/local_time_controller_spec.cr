require "../spec_helper"

describe LocalTimeController do
  it "formats its time element in the browser locale" do
    js = Crumble::StimulusControllers.to_js

    js.should contain(%(Stimulus.register("local-time", LocalTimeController);))
    js.should contain(%(new Intl.DateTimeFormat(undefined, {dateStyle: "medium", timeStyle: "short"}).format(date)))
    js.should contain("this.element.textContent")
  end
end
