import SwiftUI
import WebKit

// Mein Pferd – iPhone-App
// Das Spiel selbst ist www/index.html. Die App zeigt es an und speichert den Spielstand
// als Datei im App-Ordner (Application Support/spielstand.json). Safari hat darauf keinen Zugriff,
// der Spielstand bleibt also, bis die App gelöscht wird.

@main
struct MeinPferdApp: App {
    var body: some Scene {
        WindowGroup {
            GameView()
                .ignoresSafeArea()
                .background(Color(red: 0.486, green: 0.780, blue: 0.949))
        }
    }
}

enum Spielstand {
    static let datei: URL = {
        let ordner = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: ordner, withIntermediateDirectories: true)
        return ordner.appendingPathComponent("spielstand.json")
    }()

    static func laden() -> String? {
        try? String(contentsOf: datei, encoding: .utf8)
    }

    static func speichern(_ json: String) {
        try? json.write(to: datei, atomically: true, encoding: .utf8)
    }
}

struct GameView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let content = WKUserContentController()
        content.add(context.coordinator, name: "pferdSave")
        // Gespeicherten Spielstand vor dem Spiel bereitstellen
        var start = "window.__iosApp = true;"
        if let json = Spielstand.laden(),
           let daten = try? JSONSerialization.data(withJSONObject: [json]),
           let liste = String(data: daten, encoding: .utf8) {
            start += "window.__nativeSave = \(liste)[0];"
        }
        content.addUserScript(WKUserScript(source: start, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        config.userContentController = content

        let web = WKWebView(frame: .zero, configuration: config)
        web.isOpaque = false
        web.backgroundColor = UIColor(red: 0.486, green: 0.780, blue: 0.949, alpha: 1)
        web.scrollView.bounces = false
        web.scrollView.contentInsetAdjustmentBehavior = .never
        web.allowsBackForwardNavigationGestures = false
        web.navigationDelegate = context.coordinator

        if let seite = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "www") {
            web.loadFileURL(seite, allowingReadAccessTo: seite.deletingLastPathComponent())
        }
        return web
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        // Das Spiel schickt bei jeder Änderung den ganzen Spielstand
        func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
            if let json = message.body as? String { Spielstand.speichern(json) }
        }

        // Nur die eigene Spieldatei anzeigen, keine fremden Seiten
        func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(action.request.url?.isFileURL == true ? .allow : .cancel)
        }
    }
}
