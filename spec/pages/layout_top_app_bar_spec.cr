require "../spec_helper"

describe "pages with explicit top app bar" do
  it "renders the top app bar on the home page" do
    response_body = String.build do |io|
      request_ctx = Crumble::Server::TestRequestContext.new(
        response_io: io,
        resource: HomePage.uri_path
      )

      HomePage.handle(request_ctx).should eq(true)
      request_ctx.response.status_code.should eq(200)
      request_ctx.response.flush
    end

    response_body.should contain("id=\"#{Crumble::Material::TopAppBar::TopAppBarId}\"")
    response_body.should contain("Menu")
  end

  it "renders the top app bar on the legal notice page" do
    response_body = String.build do |io|
      request_ctx = Crumble::Server::TestRequestContext.new(
        response_io: io,
        resource: LegalNoticePage.uri_path
      )

      LegalNoticePage.handle(request_ctx).should eq(true)
      request_ctx.response.status_code.should eq(200)
      request_ctx.response.flush
    end

    response_body.should contain("id=\"#{Crumble::Material::TopAppBar::TopAppBarId}\"")
    response_body.should contain("Menu")
  end

  it "renders the top app bar on the data privacy notice page" do
    response_body = String.build do |io|
      request_ctx = Crumble::Server::TestRequestContext.new(
        response_io: io,
        resource: DataPrivacyNoticePage.uri_path
      )

      DataPrivacyNoticePage.handle(request_ctx).should eq(true)
      request_ctx.response.status_code.should eq(200)
      request_ctx.response.flush
    end

    response_body.should contain("id=\"#{Crumble::Material::TopAppBar::TopAppBarId}\"")
    response_body.should contain("Menu")
  end
end
