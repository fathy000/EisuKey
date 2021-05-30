//
//  AppDelegate.swift
//  EisuKeyLauncher
//
//  Created by 大橋航生 on 2021/05/30.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainAppId = "jp.scorebook.EisuKey"
        let isRunning = NSWorkspace.shared.runningApplications.contains { app in
            app.bundleIdentifier == mainAppId
        }
        if isRunning {
            NSApp.terminate(nil)
        } else {
            if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: mainAppId) {
                let config = NSWorkspace.OpenConfiguration()
                NSWorkspace.shared.openApplication(at: url, configuration: config) { _, _ in
                    NSApp.terminate(nil)
                }
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

