require "../push_notifications"

class ListAccessPermission
  def self.create(**args : **T) : self forall T
    super.tap { |list_access_permission| PushNotifications.notify_member_joined(list_access_permission) }
  end
end
