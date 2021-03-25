//
//  AppDelegate.swift
//  macos
//
//  Created by Andrew Glaze on 3/2/21.
//

import AppKit
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Disables tabs in running app
        _ = NSApplication.shared.windows.map { $0.tabbingMode = .disallowed }
    }
}
