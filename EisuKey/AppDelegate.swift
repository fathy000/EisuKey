//
//  AppDelegate.swift
//  EisuKey
//
//  Created by 大橋航生 on 2021/05/30.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var popover: NSPopover!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        guard let button = self.statusBarItem.button else { return }
        button.image = NSImage(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: nil)
        button.action = #selector(showHidePopover(_:))
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 350, height: 500)
        popover.behavior = .transient
//        let contentView = ContentView().environment(\.managedObjectContext, persistenceController.storageContext)
//        popover.contentViewController = NSHostingController(rootView: contentView)
//        self.popover = popover
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc private func showHidePopover(_ sender: AnyObject?) {
        guard let button = self.statusBarItem.button else { return }
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            popover.contentViewController?.view.window?.becomeKey()
        }
    }
}

