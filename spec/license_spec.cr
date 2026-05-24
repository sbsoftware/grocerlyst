require "./spec_helper"

describe "LICENSE" do
  it "excludes legal and privacy notices from the MIT license" do
    license = File.read("LICENSE")

    license.should contain("MIT License")
    license.should contain("legal notice page")
    license.should contain("privacy notice page")
    license.should contain("src/pages/legal_notice_page.cr")
    license.should contain("src/pages/data_privacy_notice_page.cr")
    license.should contain("excluded from this license")
    license.should contain("not licensed under the MIT License")
    license.should contain("may not be redistributed under the MIT License")
  end
end
