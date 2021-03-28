//
//  ShareViewController.swift
//  Translate in LiveTL
//
//  Created by Andrew Glaze on 3/15/21.
//

import Cocoa

class ShareViewController: NSViewController {
    override func loadView() {
        super.loadView()
    }

    @IBAction func send(_ sender: AnyObject?) {
        let items = (extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []

        if items.count <= 0 {
            // show error in modal
            print("no items passed???")
            return
        }

        for attachment in items {
            if attachment.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                attachment.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { data, error in
                    // show error in modal
                    guard error == nil else { print("error in kUTTypeURL: \(error!)"); return }
                    
                    let str = String(decoding: data as! Data, as: UTF8.self)
                    if let url = URL(string: str) {
                        self.perform(with: url)
                    } else {
                        // show error in modal
                        print("could not cast from kUTTypeURL to URL???")
                    }
                }
            }

            if attachment.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                attachment.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil) { data, error in
                    // show error in modal
                    guard error == nil else { print("error in kUTTypeText: \(error!)"); return }
                    
                    let str = String(decoding: data as! Data, as: UTF8.self)
                    if let url = URL(string: str) {
                        self.perform(with: url)
                    } else {
                        // show error in modal
                        print("could not cast from kUTTypeText to URL???")
                    }
                }
            }
        }
    }

    func perform(with url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        guard let vId = components.queryItems?.filter({ $0.name == "v" }).first?.value else {
            // show error in modal
            
            print("could not get vId")
            return
        }

        let appURL = URL(string: "livetl://translate/\(vId)?full=\(url.absoluteString)")!
        if NSWorkspace.shared.open(appURL) {
            self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
        } else {
            // show error in modal
            print("failed to open app???")
        }
        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
    }

    @IBAction func cancel(_ sender: AnyObject?) {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequest(withError: cancelError)
    }
}
