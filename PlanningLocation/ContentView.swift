import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        PlanningWebView(url: URL(string: "https://152-53-226-88.sslip.io/")!)
            .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct PlanningWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        let web = WKWebView(frame: .zero, configuration: config)
        web.allowsBackForwardNavigationGestures = true
        web.scrollView.keyboardDismissMode = .interactive
        web.load(URLRequest(url: url))
        return web
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}
