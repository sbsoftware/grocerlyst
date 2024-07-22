class ServiceWorker < JS::Code
  File = JavascriptFile.new("/service_worker.js", self.to_js)

  def self.uri_path
    File.uri_path
  end

  def_to_js do
    console.debug("Service Worker installed")
  end
end
