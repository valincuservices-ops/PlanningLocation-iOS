import SwiftUI
import WebKit
import UIKit

struct ContentView: View {
    var body: some View {
        PlanningWebView()
            .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct PlanningWebView: UIViewRepresentable {
    private let home = URL(string: "https://152-53-226-88.sslip.io/")!

    func makeCoordinator() -> Coordinator {
        Coordinator(home: home)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.keyboardDismissMode = .interactive

        var request = URLRequest(url: home)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 30
        webView.load(request)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let home: URL

        init(home: URL) {
            self.home = home
        }

        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
                webView.load(URLRequest(url: url))
            }
            return nil
        }

        func webView(_ webView: WKWebView,
                     didFail navigation: WKNavigation!,
                     withError error: Error) {
            showError(in: webView, error: error)
        }

        func webView(_ webView: WKWebView,
                     didFailProvisionalNavigation navigation: WKNavigation!,
                     withError error: Error) {
            showError(in: webView, error: error)
        }

        private func showError(in webView: WKWebView, error: Error) {
            let message = error.localizedDescription
                .replacingOccurrences(of: "&", with: "&amp;")
                .replacingOccurrences(of: "<", with: "&lt;")
                .replacingOccurrences(of: ">", with: "&gt;")
            let html = """
            <html><meta name="viewport" content="width=device-width,initial-scale=1">
            <body style="font-family:-apple-system;padding:28px">
            <h2>Planning Location</h2>
            <p>Connexion au serveur impossible.</p>
            <p>\(message)</p>
            <p><a href="\(home.absoluteString)">Reessayer</a></p>
            </body></html>
            """
            webView.loadHTMLString(html, baseURL: home)
        }
    }
}
