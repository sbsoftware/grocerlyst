require "./changelog_view/changelog_item"

class ChangelogView
  ToHtml.class_template do
    h3 { "17.05.2021" }
    ul do
      ChangelogItem.build do
        change_type = :improvement
        change_title =  "Typlabels für Changelogeinträge"
        description do
          "Vollkommen willkürlich und unnötig, aber ich hatte grade Spaß daran."
        end
      end
      ChangelogItem.build do
        change_type = :bugfix
        change_title = "Umgebrochene Contextmenüs repariert"
        description do
          "Bei den Suchergebnissen in der Liste."
        end
      end
    end

    h3 { "10.05.2021" }
    ul do
      ChangelogItem.build do
        change_type = :feature
        change_title = "Contextmenüs für Listeneinträge"
        description do
          "Die bisherige \"Halten\"-Geste zum Löschen ist damit erst einmal wieder abgeschafft - sie wurde ohnehin bisher von niemandem entdeckt."
        end
      end
      ChangelogItem.build do
        change_type = :feature
        change_title = "Listen löschen"
        description do
          "Über das Contextmenü kann man seine Beteiligung an einer Liste nun löschen. Für andere Nutzer bleibt sie dennoch bestehen."
        end
      end
    end

    h3 { "08.05.2021" }
    ul do
      ChangelogItem.build do
        change_type = :improvement
        change_title = "Cookie-Consent Banner hinzugefügt"
      end
      ChangelogItem.build do
        change_type = :improvement
        change_title = "Neue Domain"
        description do
          "Die App ist jetzt über https://einkaufsliste.app erreichbar. Das Übernehmen der Listen ist derzeit noch nicht möglich. Man kann aber weiterhin auch die alte URL verwenden."
        end
      end
    end

    h3 { "27.04.2021" }
    ul do
      ChangelogItem.build do
        change_type = :improvement
        change_title = "Vollbildmodus für iOS"
        description do
          "Die Webseite müsste auf Apple-Geräten jetzt automatisch im Vollbild angezeigt werden."
        end
      end
    end

    h3 { "23.04.2021" }
    ul do
      ChangelogItem.build do
        change_type = :feature
        change_title = "Changelog eingeführt"
        description = ";-)"
      end
      ChangelogItem.build do
        change_type = :improvement
        change_title = "Icon für Shopmodus in Augensymbol geändert"
        description do
          "Den Einkaufswagen fand ich eigentlich passender für den \"Shopmodus\", aber dessen Bedeutung ist keinem bisherigen Tester von alleine klar geworden."
        end
      end
      ChangelogItem.build do
        change_type = :bugfix
        change_title = "Swipe-Sensitivität für Menü verringert"
        description do
          "Das sollte für's erste verhindern, dass das Menü aus Versehen beim Scrollen aufgeht."
        end
      end
    end
  end
end
