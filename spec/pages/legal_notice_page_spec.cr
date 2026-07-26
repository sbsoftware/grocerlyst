require "../spec_helper"

describe LegalNoticePage do
  it "renders the optional second legal notice name row" do
    ENV["LEGAL_NOTICE_NAME2"] = "Second Owner"
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: LegalNoticePage.uri_path)

    LegalNoticePage.handle(ctx).should be_true
    ctx.response.flush

    response = response_io.to_s
    response.should contain("Test Owner")
    response.should contain("Second Owner")
    response.index("Test Owner").not_nil!.should be < response.index("Second Owner").not_nil!
    response.index("Second Owner").not_nil!.should be < response.index("Test Street 1").not_nil!
  ensure
    ENV["LEGAL_NOTICE_NAME2"] = ""
  end

  it "omits the second legal notice name row when it is blank" do
    ENV["LEGAL_NOTICE_NAME2"] = ""
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: LegalNoticePage.uri_path)

    LegalNoticePage.handle(ctx).should be_true
    ctx.response.flush

    response_io.to_s.should_not contain("Second Owner")
  end
end
