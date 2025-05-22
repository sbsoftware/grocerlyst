class WebManifestFile < AssetFile
  def initialize(contents)
    super("/manifest.webmanifest", contents)
  end

  def mime_type
    "application/manifest+json"
  end
end

class PNGImage < AssetFile
  def mime_type
    "image/png"
  end
end

class WebManifest < JS::Code
  File = WebManifestFile.new(self.to_js)

  Icon = PNGImage.register "grocerlyst.app", "assets/einkaufsliste.png"

  def self.uri_path
    File.uri_path
  end

  def_to_js do
    _literal_js(<<-JSON)
    {
      "name": "Grocerlyst.com",
      "short_name": "Grocerlyst",
      "icons": [
        {
          "src": "#{Icon.uri_path}",
          "sizes": "192x192",
          "type": "#{Icon.mime_type}"
        }
      ],
      "start_url": "/",
      "background_color": "#FFF",
      "theme_color": "#35A",
      "display": "standalone"
    }
    JSON
  end

  ToHtml.class_tag_attrs do
    link do
      rel = "manifest"
      href = uri_path
    end
  end

  ToHtml.class_template do
    link self
  end
end
