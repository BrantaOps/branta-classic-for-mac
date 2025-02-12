//
//  SettingsViewController.swift
//  Branta
//
//  Created by Keith Gardner on 2/2/24.
//

import Cocoa

class SettingsViewController: NSViewController {
    
    @IBOutlet weak var cadenceSelector: NSPopUpButton!
    
    @IBOutlet weak var notifyForBTCAddressOutlet: NSSwitch!
    @IBOutlet weak var notifyForSeedOutlet: NSSwitch!
    @IBOutlet weak var notifyForXPubOutlet: NSSwitch!
    @IBOutlet weak var notifyForXPrvOutlet: NSSwitch!
    @IBOutlet weak var notifyForNPubOutlet: NSSwitch!
    @IBOutlet weak var notifyForNSecOutlet: NSSwitch!
    @IBOutlet weak var notifyUponLaunchOutlet: NSSwitch!
    @IBOutlet weak var notifyUponStatusChangeOutlet: NSSwitch!
    @IBOutlet weak var showInDockOutlet: NSSwitch!
    @IBOutlet weak var lastSyncLabel: NSTextField!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.appearance = NSAppearance(named: .darkAqua)
        
        self.title = ""
        
        let pref = Settings.readFromDefaults()
        let lastSyncPref = pref[Branta.Constants.Prefs.LAST_SYNC] as? String
        if lastSyncPref != nil {
            lastSyncLabel.stringValue = lastSyncPref!
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        configureCadence()
        configureSwitches()
        BrantaLogger.log(s: Settings.readFromDefaults())
                
        if let window = view.window {
            window.titlebarAppearsTransparent = true
            window.title = ""
        }
        
        // TODO - the other observers need to remove themselves.
        Bridge.addObserver(self)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        Bridge.removeObserver(self)
    }
    
    @objc func setCadence(sender: NSPopUpButton) {
        Settings.set(key: Branta.Constants.Prefs.SCAN_CADENCE_WORDING, value: Branta.Constants.Prefs.CADENCE_OPTIONS[sender.indexOfSelectedItem].0)
        Settings.set(key: Branta.Constants.Prefs.SCAN_CADENCE,         value: Branta.Constants.Prefs.CADENCE_OPTIONS[sender.indexOfSelectedItem].1)
    }
    
    @IBAction func setNotifyForBTCAddress(_ sender: Any) {
        setFor(s: sender as! NSSwitch, key: Branta.Constants.Notify.FOR_BTC_ADDRESS)
    }
    
    @IBAction func setNotifyForSeed(_ sender: Any) {
        setFor(s: sender as! NSSwitch, key: Branta.Constants.Notify.FOR_SEED)
    }
    
    @IBAction func setNotifyForXPub(_ sender: Any) {
        setFor(s: sender as! NSSwitch, key: Branta.Constants.Notify.FOR_XPUB)
    }
    
    @IBAction func setNotifyForXPrv(_ sender: Any) {
        setFor(s: sender as! NSSwitch, key: Branta.Constants.Notify.FOR_XPRV)
    }
    
    @IBAction func setNotifyForNPub(_ sender: Any) {
        setFor(s: sender as! NSSwitch, key: Branta.Constants.Notify.FOR_NPUB)
    }
    
    @IBAction func setNotifyForNSec(_ sender: Any) {
        setFor(s: sender as! NSSwitch, key: Branta.Constants.Notify.FOR_NSEC)
    }
    
    @IBAction func setNotifyUponLaunch(_ sender: Any) {
        setFor(s: sender as! NSSwitch, key: Branta.Constants.Notify.UPON_LAUNCH)
    }
    
    @IBAction func setNotifyUponStatusChange(_ sender: Any) {
        setFor(s: sender as! NSSwitch, key: Branta.Constants.Notify.UPON_STATUS_CHANGE)
    }
    
    @IBAction func setShowInDock(_ sender: Any) {
        setFor(s: sender as! NSSwitch, key: Branta.Constants.Prefs.SHOW_IN_DOCK)
        
        if (sender as! NSSwitch).state == .on {
            NSApp.setActivationPolicy(.regular)
        } else {
            NSApp.setActivationPolicy(.accessory)
        }
        
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    @IBAction func refresh(_ sender: Any) {
        BrantaLogger.log(s: "SettingsViewController#refresh.")
        Bridge.fetchLatest { success in }
    }
    
    @IBAction func help(_ sender: Any) {
        let url = URL(string: "https://docs.branta.pro/")!
        NSWorkspace.shared.open(url)
    }
}

extension SettingsViewController: BridgeObserver {
    func bridgeDidFetch(content: String) {
        lastSyncLabel.stringValue = content
    }
}

extension SettingsViewController {
    private
    
    func setFor(s: NSSwitch, key: String) {
        if s.state == .on {
            Settings.set(key: key, value: true)
        } else {
            Settings.set(key: key, value: false)
        }
    }
    
    func configureSwitches() {
        let settings = Settings.readFromDefaults()
        
        for setting in settings {
            if setting.key == Branta.Constants.Notify.FOR_BTC_ADDRESS {
                notifyForBTCAddressOutlet.state = setting.value as! Bool == true ? .on : .off
            } else if setting.key == Branta.Constants.Notify.FOR_SEED {
                notifyForSeedOutlet.state = setting.value as! Bool == true ? .on : .off
            } else if setting.key == Branta.Constants.Notify.FOR_XPUB {
                notifyForXPubOutlet.state = setting.value as! Bool == true ? .on : .off
            } else if setting.key == Branta.Constants.Notify.FOR_XPRV {
                notifyForXPrvOutlet.state = setting.value as! Bool == true ? .on : .off
            } else if setting.key == Branta.Constants.Notify.FOR_NPUB {
                notifyForNPubOutlet.state = setting.value as! Bool == true ? .on : .off
            } else if setting.key == Branta.Constants.Notify.FOR_NSEC {
                notifyForNSecOutlet.state = setting.value as! Bool == true ? .on : .off
            } else if setting.key == Branta.Constants.Notify.UPON_LAUNCH {
                notifyUponLaunchOutlet.state = setting.value as! Bool == true ? .on : .off
            } else if setting.key == Branta.Constants.Notify.UPON_STATUS_CHANGE {
                notifyUponStatusChangeOutlet.state = setting.value as! Bool == true ? .on : .off
            } else if setting.key == Branta.Constants.Prefs.SHOW_IN_DOCK {
                BrantaLogger.log(s: "settings \(Branta.Constants.Prefs.SHOW_IN_DOCK) to \(setting.value)")
                showInDockOutlet.state = setting.value as! Bool == true ? .on : .off
            }
            
        }
    }
    
    func configureCadence() {
        let settings = Settings.readFromDefaults()
        
        for cadence in Branta.Constants.Prefs.CADENCE_OPTIONS {
            cadenceSelector.addItem(withTitle: cadence.0)
        }
        
        // TODO - engine hooks, cold start
        let cadenceStr = settings[Branta.Constants.Prefs.SCAN_CADENCE_WORDING] as! String
        if let index = Branta.Constants.Prefs.CADENCE_OPTIONS.firstIndex(where: { $0.0 == cadenceStr }) {
            cadenceSelector.selectItem(at: index)
        }
        
        cadenceSelector.target = self
        cadenceSelector.action = #selector(setCadence)
    }
}
