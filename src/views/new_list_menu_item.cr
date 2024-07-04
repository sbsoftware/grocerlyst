class NewListMenuItem
  ToHtml.class_template do
    form action: ListResource.uri_path, method: "POST" do
      input Classes::LinkButton, type: "submit", name: "submit", value: "Neue Liste"
    end
  end
end
