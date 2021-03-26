//
//  WebView.swift
//  macos
//
//  Created by Andrew Glaze on 2/21/21.
//

import RxCocoa
import RxSwift
import SwiftUI
import WebKit
import common

struct WebView: NSViewRepresentable {
    var request: URLRequest
    var model: WatchModelType
    let chatEventObservable: BehaviorRelay<(Double, String)?>
    let bag = DisposeBag()

    func makeNSView(context: Context) -> WKWebView {
        // Set up Web View
        let webView = WKWebView()
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:85.0) Gecko/20100101 Firefox/85.0"
        // Inject custom JS
        do {
            let path = Bundle.main.resourcePath! + "/common_common.bundle/Contents/Resources/WindowInjector.js"
            let js = try String(contentsOfFile: path, encoding: .utf8)
            let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)

            webView.configuration.userContentController.addUserScript(script)
            webView.configuration.userContentController.add(model as! WatchModel, name: "ios_messageReceive")
        } catch {
            print(error)
        }

        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.load(request)

        // Post timestamp messages to window, for archive support
        Observable.combineLatest(model.output.replayControl, chatEventObservable).filter { $0.0 == true }
            .compactMap { $0.1 }
            .subscribe(onNext: { time, id in
                let js = """
                    window.postMessage({ "yt-player-video-progress": \(time), video: "\(id)"}, '*');
                """
                DispatchQueue.main.async {
                    nsView.evaluateJavaScript(js, completionHandler: nil)
                }
            }).disposed(by: bag)
    }
}

/*
 struct WebView_Previews: PreviewProvider {
     static var previews: some View {
         WebView(request: URLRequest(url: URL(string: "https://www.google.com")!), model: WatchModel(AppServices()))
     }
 }
 */
