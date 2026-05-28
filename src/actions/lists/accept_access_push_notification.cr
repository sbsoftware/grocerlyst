require "../../push_notifications"
require "../../models/list"

class List::AcceptAccessAction
  def form : Form
    return previous_def if ctx.handler == self

    @form ||= Form.new(ctx, model, access_token: model.access_token.value)
  end

  def model_action_controller
    list_access_permission = ListAccessPermission.where(**model._access_model_attributes(ctx)).first?

    previous_def
    return if list_access_permission || ctx.response.status_code != 303

    if list_access_permission = ListAccessPermission.where(**model._access_model_attributes(ctx)).first?
      PushNotifications.notify_member_joined(list_access_permission)
    end
  end
end
