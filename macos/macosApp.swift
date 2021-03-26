//
//  macosApp.swift
//  macos
//
//  Created by Andrew Glaze on 2/5/21.
//

import SwiftUI
import XCDYouTubeKit

@main
struct macosApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            StreamerListView()
        }
        .commands {
            CommandGroup(replacing: .newItem) {} // remove new tabs
        }

        Settings {
            SettingsView()
        }
    }
}
