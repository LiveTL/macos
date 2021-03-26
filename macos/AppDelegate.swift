//
//  AppDelegate.swift
//  macos
//
//  Created by Andrew Glaze on 3/2/21.
//

import AppKit
import SwiftUI
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Disables tabs in running app
        _ = NSApplication.shared.windows.map {
            $0.tabbingMode = .disallowed
        }
        
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(self.handleAppleEvent(event:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }

    @objc func handleAppleEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        guard let appleEventDescription = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) else { return }

        guard let appleEventURLString = appleEventDescription.stringValue else { return }
        
        let appleEventURL = URL(string: appleEventURLString)
        
        print("Received URL: \(String(describing: appleEventURL))")
        
        if appleEventURL == nil { print("no URL"); return }
        
        let id = appleEventURL!.path.replacingOccurrences(of: "/", with: "")
        
        let contentView = LiveStreamView(id: id).frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
        if NSApplication.shared.windows.first == nil {
            let window = NSWindow(contentRect: NSMakeRect(0, 0, 1440, 1080), styleMask: [.closable, .titled, .resizable, .miniaturizable], backing: .buffered, defer: true)
            window.isReleasedWhenClosed = false
            window.center()
            window.orderFrontRegardless()
        }
        
        if let window = NSApplication.shared.windows.first {
            window.contentView = NSHostingView(rootView: contentView)
            window.makeKeyAndOrderFront(nil)
            
        }
    }
}
