require "./spec_helper"

private class RecordingPushSender < PushNotifications::Sender
  getter sessions = [] of String
  getter payloads = [] of String

  def send_to_sessions(sessions : Enumerable(Crumble::Web::Push::Server::Subscription), payload : String) : Nil
    sessions.each { |subscription| @sessions << subscription.session_id }
    payloads << payload
  end
end

describe PushNotifications do
  before_each do
    SpecSupport.reset_db!
  end

  it "notifies subscribed existing list members when a new member joins" do
    sender = RecordingPushSender.new
    PushNotifications.sender = sender
    list = List.create(name: "Dinner", session_id: "owner-session")
    reloaded_list = List.where(id: list.id).first
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: List::AcceptAccessAction.uri_path(reloaded_list.id.value), body: "access_token=#{reloaded_list.access_token.value}")

    ListAccessPermission.create(list_id: list.id, session_id: "owner-session", name: "Alice")
    ListAccessPermission.create(list_id: list.id, session_id: "unsubscribed-session", name: "Chris")
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: "owner-session", web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/owner", p256dh: "p256dh", auth: "auth")))
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: ctx.session.id.to_s, web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/joining", p256dh: "p256dh", auth: "auth")))
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: "outside-session", web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/outside", p256dh: "p256dh", auth: "auth")))

    List::AcceptAccessAction.handle(ctx).should be_true

    sender.sessions.should eq(["owner-session"])
    sender.payloads.size.should eq(1)
    JSON.parse(sender.payloads.first)["body"].as_s.should eq("Someone joined Dinner")
  end
end
