//
//  AppDelegate.swift
//  EisuKey
//
//  Created by 大橋航生 on 2021/05/30.
//

import Cocoa
import SwiftUI
import Sauce

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarItem: NSStatusItem!
    private var popover: NSPopover!
    private var timer: Timer?
    private let eisuKeyCode = Sauce.shared.keyCode(for: .eisu)
    
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
        
        setTimer()
        
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: handleKeyboardEvent)
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: handleKeyboardEvent)
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
    
    private func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: handleTimerEvent)
    }
    
    private func handleTimerEvent(timer: Timer) {
        print("handle timer event")
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        
        let eisuEvent = CGEvent(keyboardEventSource: src, virtualKey: eisuKeyCode, keyDown: true)
        
        eisuEvent?.post(tap: .cghidEventTap)
    }
    
    private func handleKeyboardEvent(_ event: NSEvent) {
        if event.keyCode == eisuKeyCode {
            print("get eisu key event")
            return
        }
        print("handle key down")
        timer?.invalidate()
        setTimer()
    }
}

