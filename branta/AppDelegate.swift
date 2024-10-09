//
//  AppDelegate.swift
//  branta
//
//  Created by Keith Gardner on 11/17/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // App Store Build
    let BUILD_FOR_APP_STORE = false
    
    private var statusItem: NSStatusItem?
    var mainWindowController: NSWindowController?
    var newKeyWindow: NSWindow?
    var foreground: Bool = true
    var notificationManager: BrantaNotify?
    
    private let AUTOMATIONS = [Clipboard.self, Verify.self, Foreground.self]
    
    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let queryItems = components.queryItems {
                var nameValue: String?
                var publicKeyValue: String?

                for queryItem in queryItems {
                    if queryItem.name == "name" {
                        nameValue = queryItem.value
                    } else if queryItem.name == "publicKey" {
                        publicKeyValue = queryItem.value
                    } else if queryItem.name == "whisper", let v = queryItem.value {
                        Whisper.injectByName(name: v, showConfirmation: true)
                    }
                }

                if let n = nameValue, let p = publicKeyValue {
                    AddKeyViewController.saveKey(name: n, key: p, showConfirmation: true)
                }
            }
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        start()
    }
    
    // Dock Icon Handler
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            MenuHelper.openBrantaFromDock()
        }
        return true
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        //wipeDefaults() // For dev use
        foreground = true
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        foreground = false
    }
    
    @objc func didTapClipboard() {
        MenuHelper.didTapClipboard()
    }
    
    @objc func didTapWallets() {
        MenuHelper.didTapWallets()
    }
    
    @objc func didTapSettings() {
        MenuHelper.openSettingsWindow()
    }
    
    @objc func didTapKeys() {
        MenuHelper.openKeysWindow()
    }
    
    @objc func didTapWhisper() {
        MenuHelper.didTapWhisper()
    }
    
    @objc func didTapHelp() {
        MenuHelper.openHelp()
    }
    
    @objc func getUpdate(_ sender: NSMenuItem) {
        if let tag = sender.representedObject {
            if BUILD_FOR_APP_STORE {
                BrantaLogger.log(s: "Opening App Store: \(tag)")
                if let url = URL(string: Branta.Constants.Urls.APP_STORE) {
                    NSWorkspace.shared.open(url)
                }
            } else {
                BrantaLogger.log(s: "Fetching tag: \(tag)")
                let github = "https://github.com/BrantaOps/branta-mac/releases/download/\(tag)/Branta-\(tag).dmg.zip"
                if let url = URL(string: github) {
                    NSWorkspace.shared.open(url)
                }
            }
        }
    }
}

extension AppDelegate {
    private
    
    func setupMenu(status:String) {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        let statusItem = self.statusItem!
        let button = statusItem.button!
        button.image = NSImage(named: "menuicon")
        
        let menu = NSMenu()
        
        let authItem = NSMenuItem(title: status, action: nil, keyEquivalent: "")
        menu.addItem(authItem)
        
        let clipboardItem = NSMenuItem(title: NSLocalizedString("Clipboard", comment: ""), action: #selector(didTapClipboard), keyEquivalent: Branta.Constants.Shortcut.CLIPBOARD)
        menu.addItem(clipboardItem)
        
        let walletsItem = NSMenuItem(title: NSLocalizedString("Wallets", comment: ""), action: #selector(didTapWallets), keyEquivalent: Branta.Constants.Shortcut.WALLETS)
        menu.addItem(walletsItem)

        let keysItem = NSMenuItem(title: NSLocalizedString("Keys", comment: ""), action: #selector(didTapKeys), keyEquivalent: Branta.Constants.Shortcut.KEYS)
        menu.addItem(keysItem)
        
        let whisperItem = NSMenuItem(title: NSLocalizedString("Whisper", comment: ""), action: #selector(didTapWhisper), keyEquivalent: Branta.Constants.Shortcut.WHISPER)
        menu.addItem(whisperItem)

        let settingsItem = NSMenuItem(title: NSLocalizedString("Settings", comment: ""), action: #selector(didTapSettings), keyEquivalent: Branta.Constants.Shortcut.SETTINGS)
        menu.addItem(settingsItem)
        

        
        let helpItem = NSMenuItem(title: NSLocalizedString("Help", comment: ""), action: #selector(didTapHelp), keyEquivalent: Branta.Constants.Shortcut.HELP)
        menu.addItem(helpItem)
        
        Updater.checkForUpdates { updatesAvailable, tag in
            if updatesAvailable {
                let updateItem = NSMenuItem(title: "Update Available", action: #selector(self.getUpdate(_:)), keyEquivalent: Branta.Constants.Shortcut.UPDATE)
                updateItem.representedObject = tag
                menu.addItem(updateItem)
            } else {
                // TODO. For now, let the user know branta is up to date.
                // But we should mention something about the manifest/runtime hashes later.
                var strValue = "Latest Version"
                if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                    strValue = "Latest Version: \(version)."
                }
                let updateItem = NSMenuItem(title: strValue, action: nil, keyEquivalent: "")
                menu.addItem(updateItem)
            }
        }
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: Branta.Constants.Shortcut.QUIT))
        statusItem.menu = menu
    }
    
    func start() {                
        setupMenu(status: Branta.Constants.Misc.ACTIVE)
        if notificationManager == nil {
            notificationManager = BrantaNotify()
            notificationManager?.requestAuthorization()
        }
        
        for automation in AUTOMATIONS {
            automation.run()
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event) -> NSEvent? in
            if event.modifierFlags.contains(.command), event.keyCode == Branta.Constants.KeyCodes.COMMA {
                MenuHelper.openSettingsWindow()
            }
            if event.modifierFlags.contains(.command), event.keyCode == Branta.Constants.KeyCodes.K {
                MenuHelper.openKeysWindow()
            }
            return event
        }
        
        let pref = Settings.readFromDefaults()
        let showInDock = pref[Branta.Constants.Prefs.SHOW_IN_DOCK] as? Bool
        
        if showInDock != nil && showInDock! {
            NSApp.setActivationPolicy(.regular)
        } else {
            NSApp.setActivationPolicy(.accessory)
        }
    }
    
    func wipeDefaults() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            dumpBrantaPrefs()
            UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
            BrantaLogger.log(s: "Erased UserDefaults.")
        }
    }
    
    func dumpBrantaPrefs() {
        let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
        
        for (key, value) in defaultsDictionary {
            if (key == Branta.Constants.Prefs.KEY) {
                BrantaLogger.log(s: "UserDefaults:\(key): \(value)")
            }
        }
    }
}
