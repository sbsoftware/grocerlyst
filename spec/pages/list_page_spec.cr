require "../spec_helper"

describe ListPage do
  before_each do
    SpecSupport.reset_db!
  end

  it "redirects to the home page when the list is not accessible" do
    list = List.create(name: "Groceries", session_id: "another-session")
    ctx = Crumble::Server::TestRequestContext.new(method: "GET", resource: ListPage.uri_path(list_id: list.id.value))

    ListPage.handle(ctx).should be_true

    ctx.response.status_code.should eq(303)
    ctx.response.headers["Location"].should eq(HomePage.uri_path)
    ctx.session.last_used_list_id.should be_nil
  end

  it "renders an accessible list and stores it as last used" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: ListPage.uri_path(list_id: list.id.value))

    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)

    ListPage.handle(ctx).should be_true
    ctx.response.flush

    ctx.response.status_code.should eq(200)
    response_io.to_s.should contain("Weekly Shopping")
    response_io.to_s.should contain("id=\"#{Crumble::Material::TopAppBar::TopAppBarId}\"")
    response_io.to_s.should contain("Get notifications when your lists change.")
    response_io.to_s.should contain(PushSubscriptionBannerController.subscribe_action("click").to_s)
    response_io.to_s.should contain("Menu")
    response_io.to_s.should contain("visibility")
    response_io.to_s.should contain("history")
    response_io.to_s.should contain(ListItemHiderController.switch_target.to_s)
    ctx.session.last_used_list_id.should eq(list.id.value)
  end

  it "renders the push subscription banner in the accepted language" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    response_io = IO::Memory.new
    headers = HTTP::Headers{"Accept-Language" => "de"}
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: ListPage.uri_path(list_id: list.id.value), headers: headers)

    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)

    ListPage.handle(ctx).should be_true
    ctx.response.flush

    response_io.to_s.should contain("Benachrichtigungen erhalten, wenn sich deine Listen ändern.")
    response_io.to_s.should contain("Abonnieren")
  end

  it "hides the push subscription banner when the current session is subscribed" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: ListPage.uri_path(list_id: list.id.value))

    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: ctx.session.id.to_s, web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/push", p256dh: "p256dh", auth: "auth")))

    ListPage.handle(ctx).should be_true
    ctx.response.flush

    response_io.to_s.should_not contain("Get notifications when your lists change.")
  end
end
