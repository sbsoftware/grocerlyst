require "../spec_helper"

describe DataPrivacyNoticePage do
  it "renders the optional second legal notice name row in the controller address" do
    ENV["LEGAL_NOTICE_NAME2"] = "Second Owner"
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: DataPrivacyNoticePage.uri_path)

    DataPrivacyNoticePage.handle(ctx).should be_true
    ctx.response.flush

    response = response_io.to_s
    response.should contain("Test Owner")
    response.should contain("Second Owner")
    response.index("Test Owner").not_nil!.should be < response.index("Second Owner").not_nil!
    response.index("Second Owner").not_nil!.should be < response.index("Test Street 1").not_nil!
  ensure
    ENV["LEGAL_NOTICE_NAME2"] = ""
  end
end
