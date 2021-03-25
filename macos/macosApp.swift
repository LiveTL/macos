//
//  macosApp.swift
//  macos
//
//  Created by Mason Phillips on 3/24/21.
//

import SwiftUI

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
