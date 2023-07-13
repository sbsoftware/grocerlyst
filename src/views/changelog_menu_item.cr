class ChangelogMenuItem < Template
  template do
    a href(ChangelogResource.uri_path) do
      "Changelog"
    end
  end
end
