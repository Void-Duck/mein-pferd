# Mein Pferd 🐴

Pferde-Tamagotchi für Alea: Pferd erstellen, füttern, pflegen und mit Minispielen Münzen verdienen.

## iPhone-App (empfohlen)
Die App speichert den Spielstand **in der App selbst**. Er bleibt, bis die App gelöscht wird.

Die fertige App liegt unter **Releases** → „Mein Pferd für iPhone x.y.z“ → `MeinPferd-x.y.z.ipa`.
Weil sie nicht aus dem App Store kommt, wird sie mit einem PC und deiner Apple-ID aufs iPhone gebracht:

1. Auf dem PC **Sideloadly** installieren (https://sideloadly.io, Windows oder Mac; unter Windows zusätzlich iTunes von apple.com, nicht aus dem Microsoft Store)
2. iPhone per Kabel anschließen und am iPhone „Vertrauen“ bestätigen
3. Die `.ipa`-Datei in Sideloadly ziehen, Apple-ID eintragen → **Start**
4. Auf dem iPhone: **Einstellungen → Allgemein → VPN und Geräteverwaltung** → deine Apple-ID → **Vertrauen**
5. Ab iOS 16 einmalig: **Einstellungen → Datenschutz & Sicherheit → Entwicklermodus** einschalten, iPhone neu starten

Mit einer **kostenlosen Apple-ID** läuft die App 7 Tage. Danach in Sideloadly einfach erneut installieren
(oder dort „Automatisch auffrischen“ einschalten). **Der Spielstand bleibt dabei erhalten**, solange die App nicht gelöscht wird.
Mit einem bezahlten Apple-Entwicklerkonto (99 €/Jahr) läuft sie ein Jahr.

Updates genauso: neue `.ipa` aus Releases über die alte installieren, der Spielstand bleibt.

## Web-Version
https://void-duck.github.io/mein-pferd/ – im Safari-Tab löscht das iPhone den Spielstand beim Schließen des Tabs.
Dort deshalb nur über „Teilen → Zum Home-Bildschirm“ nutzen.

---
Dieses Repo wird automatisch befüllt. Die Quellen liegen im privaten Repo `Meine-Apps` im Ordner `Pferde/`
und werden mit `sh Pferde/web/deploy-pages.sh` hierher veröffentlicht. GitHub baut daraus die iPhone-App.
