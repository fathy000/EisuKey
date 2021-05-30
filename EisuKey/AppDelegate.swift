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
    private let eisuKeyCode = Sauce.shared.keyCode(for: .eisu)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        checkAvailability()
        setupViews()
        setupObservers()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private func checkAvailability() {
        // ウィンドウ外でキーボードイベントも検知したい場合
        // [システム環境設定]->[セキュリティーとプライバシー]->[アクセシビリティ]で有効にするのを促す
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)

        if !accessEnabled {
           let alert = NSAlert()
           alert.messageText = "EisuKey.app"
           alert.informativeText = "システム環境設定でEisuKeyのアクセシビリティを有効にして、このアプリを再度起動する必要があります"
           alert.addButton(withTitle: "OK")
           alert.runModal()
           // 設定できたらアプリを再起動しないと意味ないためアプリ強制終了
           NSApplication.shared.terminate(self)
        }
    }
    
    private func setupViews() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        guard let button = self.statusBarItem.button else { return }
        button.image = NSImage(named: "toEi")!
        button.action = #selector(handleStatusBarItemTapped(_:))
        
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 350, height: 500)
        popover.behavior = .transient
        let contentView = ContentView()
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
    }
    
    private func setupObservers() {
        // アプリ変更監視
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(handleAppChangeNotification(_:)),
                                                          name: NSWorkspace.didActivateApplicationNotification,
                                                          object: nil)
    }
    
    /// アプリ変更イベント
    @objc private func handleAppChangeNotification(_ sender: Notification) {
        changeToEisuInput()
    }
    
    /// ステータスバーがタップされた
    @objc private func handleStatusBarItemTapped(_ sender: AnyObject?) {
        guard let button = self.statusBarItem.button else { return }
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            popover.contentViewController?.view.window?.becomeKey()
        }
    }
    
    private func changeToEisuInput() {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        
        let eisuEvent = CGEvent(keyboardEventSource: src, virtualKey: eisuKeyCode, keyDown: true)
        
        eisuEvent?.post(tap: .cghidEventTap)
    }
}

/*
 TODO: かな文字モードも作る
 
 */

