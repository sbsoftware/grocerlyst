class PushSubscriptionBannerController < Stimulus::Controller
  action :dismiss do |event|
    event.preventDefault._call if event

    this.element.remove._call
  end

  action :subscribe do |event|
    event.preventDefault._call if event

    that = this
    subscription_controller = this.application.getControllerForElementAndIdentifier._call(
      document.body,
      CrumbleWebPush::SubscriptionController.controller_name.to_js_ref
    )
    return nil unless subscription_controller

    return subscription_controller.process_subscription_change._call("subscribe").then do |subscription|
      that.element.remove._call if subscription
      return subscription
    end
  end
end
