class LegalNoticeView
  ToHtml.class_template do
    div Classes::TextView do
      h1 { "Impressum" }

      h2 { "Angaben gemäß § 5 TMG" }
      p do
        span { "Stefan Bilharz" }
        br
        span { "Riederstr. 16" }
        br
        span { "70619 Stuttgart" }
        br
        span { "Germany" }
      end

      h2 { "Kontakt" }
      p do
        span { "E-Mail: kontakt@sbsoftware.de" }
        br
        span { "Telefon: +49 176 69941209" }
      end

      h2 { "EU-Streitschlichtung" }
      p do
        span { "Die Europäische Kommission stellt eine Plattform zur Online-Streitbeilegung (OS) bereit: " }
        a(href: "https://ec.europa.eu/consumers/odr") { "https://ec.europa.eu/consumers/odr" }
        span { "." }
        br
        span { "Unsere E-Mail-Adresse finden Sie oben im Impressum." }
      end

      h2 { "Verbraucherstreitbeilegung / Universalschlichtungsstelle" }
      p do
        "Wir sind nicht bereit oder verpflichtet, an Streibeilegungsverfahren vor einer Verbraucherschlichtungsstelle teilzunehmen."
      end

      h2 { "Haftung für Inhalte" }
      p do
        "Als Diensteanbieter sind wir gemäß § 7 Abs. 1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen."
      end
      p do
        "Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt. Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. Bei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen."
      end

      h2 { "Haftung für Links" }
      p do
        "Unser Angebot enthält Links zu externen Websites Dritter, auf deren Inhalte wir keinen Einfluss haben. Deshalb können wir für diese fremden Inahlte auch keine Gewähr übernehmen. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. Die verlinkten Seiten wurden zum Zeitpunkt der Verlinkung auf mögliche Rechtsverstöße überprüft. Rechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar."
      end
      p do
        "Eine permanente inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen."
      end

      h2 { "Urheberrecht" }
      p do
        "Die durch die Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechts bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers. Downloads und Kopien dieser Seite sind nur für den privaten, nicht kommerziellen Gebrauch gestattet."
      end
      p do
        "Soweit die Inhalte auf dieser Seite nicht vom Betreiber erstellt wurden, werden die Urheberrechte Dritter beachtet. Insbesondere werden Inhalte Dritter als solche gekennzeichnet. Sollten Sie trotzdem auf eine Urheberrechtsverletzung aufmerksam werden, bitten wir um einen entsprechenden Hinweis. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Inhalte umgehend entfernen."
      end

      p do
        "Quelle: "
        a(href: "https://www.e-recht24.de") { "eRecht24" }
      end
    end
  end
end
