//
//  MenuHelper.swift
//  Branta
//
//  Created by Keith Gardner on 2/3/24.
//

import Cocoa

class MenuHelper {
    class func openHelp(){
        let url = URL(string: "https://docs.branta.pro/")!
        NSWorkspace.shared.open(url)
    }
    
    class func didTapClipboard() {
        if let w = NSApplication.shared.mainWindow,
           let vc = w.contentViewController as? TabViewController {
            vc.selectTab(at: Branta.Constants.Tabs.CLIPBOARD)
        }
    }
    
    class func didTapWallets() {
        if let w = NSApplication.shared.mainWindow,
           let vc = w.contentViewController as? TabViewController {
            vc.selectTab(at: Branta.Constants.Tabs.WALLETS)
        }
    }
    
    class func openKeysWindow() {
        if let w = NSApplication.shared.mainWindow,
           let vc = w.contentViewController as? TabViewController {
            vc.selectTab(at: Branta.Constants.Tabs.KEYS)
        }
    }
    
    class func didTapWhisper() {
        if let w = NSApplication.shared.mainWindow,
           let vc = w.contentViewController as? TabViewController {
            vc.selectTab(at: Branta.Constants.Tabs.WHISPER)
        }
    }
    
    class func openSettingsWindow() {
        if let w = NSApplication.shared.mainWindow,
           let vc = w.contentViewController as? TabViewController {
            vc.selectTab(at: Branta.Constants.Tabs.SETTINGS)
        }
    }
    
    class func openBrantaFromDock() {
        let appDelegate = NSApp.delegate as? AppDelegate
        
        if let window = appDelegate?.mainWindowController?.window {
            if !window.isVisible {
                window.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        } else {
            if let existingWindow = NSApp.mainWindow, existingWindow.isVisible {
                existingWindow.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
            } else {
                appDelegate?.mainWindowController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
                    .instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("MainWindowController"))
                as? NSWindowController
                
                appDelegate?.mainWindowController?.showWindow(nil)
            }
        }
    }
}
