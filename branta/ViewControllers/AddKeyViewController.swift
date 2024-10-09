//
//  AddKeyViewController.swift
//  Branta
//
//  Created by Keith Gardner on 6/24/24.
//

import Cocoa

class AddKeyViewController: NSViewController {
    @IBOutlet weak var nameField: NSTextField!
    @IBOutlet weak var keyField: NSTextField!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.appearance = NSAppearance(named: .darkAqua)
        if let window = view.window {
            window.titlebarAppearsTransparent = true
            window.title = ""
        }
    }
    
    @IBAction func saveKey(_ sender: Any) {
        guard BitcoinKeys.isPubKey(candidate: keyField.stringValue) else {
            return
        }
        
        AddKeyViewController.saveKey(name: nameField.stringValue, key: keyField.stringValue)
        clearTextFields()
    }
    
    private
    
    func clearTextFields() {
        nameField.stringValue = ""
        keyField.stringValue = ""
    }
    
    class func saveKey(name: String, key: String, showConfirmation: Bool = false) {
        if var keys = Settings.readFromDefaults()[Branta.Constants.Prefs.XPUBS] as? [String:String] {
            keys[name] = key
            Settings.set(key: Branta.Constants.Prefs.XPUBS, value: keys)
        } else {
            let keys = [name: key]
            Settings.set(key: Branta.Constants.Prefs.XPUBS, value: keys)
        }
        AddKeyViewController.notifyObservers()
        
        if showConfirmation {
            let alert = NSAlert()
            alert.messageText = "Added Public Key: \(name)"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
}

// OBSERVER ------------------------------------------------------------------------------------------
extension AddKeyViewController {
    private static var observers = [KeysObserver]()

    static func addObserver(_ observer: KeysObserver) {
        observers.append(observer)
    }
    
    static func removeObserver(_ observer: KeysObserver) {
        observers.removeAll { $0 === observer }
    }
    
    static func notifyObservers() {
        for observer in observers {
            observer.contentDidUpdate()
        }
    }
}
