//
//  Settings.swift
//  Branta
//
//  Created by Keith Gardner on 2/2/24.
//

import Foundation

class Settings {

    private static var prefHash : [String:Any] = [
        // Clipboard
        Branta.Constants.Notify.FOR_BTC_ADDRESS: true,
        Branta.Constants.Notify.FOR_SEED: true,
        Branta.Constants.Notify.FOR_XPUB: true,
        Branta.Constants.Notify.FOR_XPRV: true,
        Branta.Constants.Notify.FOR_NPUB: true,
        Branta.Constants.Notify.FOR_NSEC: true,
        // Wallet
        Branta.Constants.Prefs.SCAN_CADENCE: Branta.Constants.Prefs.DEFAULT_SCAN_CADENCE,
        Branta.Constants.Prefs.SCAN_CADENCE_WORDING: Branta.Constants.Prefs.DEFAULT_SCAN_CADENCE_WORDING,
        Branta.Constants.Notify.UPON_LAUNCH: true,
        Branta.Constants.Notify.UPON_STATUS_CHANGE: true,
        Branta.Constants.Prefs.SHOW_IN_DOCK: true,
        Branta.Constants.Prefs.LAST_SYNC: "-",
        // Public Keys
        Branta.Constants.Prefs.XPUBS: [String: String](),
        // Whispers
        Branta.Constants.Prefs.WHISPERS: []
    ]
    
    static func readFromDefaults() -> [String: Any] {
        if let v = UserDefaults.standard.string(forKey: Branta.Constants.Prefs.KEY) {
            guard let jsonData = v.data(using: .utf8) else {
                BrantaLogger.log(s: "Failed to convert JSON string to Data")
                return [:]
            }

            do {
                if let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    prefHash = dict // Set in-memory values from persistant storage
                    return dict
                } else {
                    BrantaLogger.log(s: "Failed to convert JSON to Dictionary")
                }
            } catch {
                BrantaLogger.log(s: "Error parsing JSON: \(error)")
            }
        } else {
            BrantaLogger.log(s: "No string found for key \(Branta.Constants.Prefs.KEY) in UserDefaults.")
            return prefHash
        }
        return [:]

    }
    
    static func set(key: String, value: Any) {
        BrantaLogger.log(s: "Preferences.swift setting \(key):\(value)")
        prefHash[key] = value
        saveToDefaults()
        
        // Reset ongoing automations
        if key == Branta.Constants.Prefs.SCAN_CADENCE {
            Verify.updateTimer()
        }
    }
    
    private
    
    static func saveToDefaults() {
        UserDefaults.standard.set(toJSON(), forKey: Branta.Constants.Prefs.KEY)
        UserDefaults.standard.synchronize()
    }
    
    static func toJSON() -> String {
        if JSONSerialization.isValidJSONObject(prefHash) {
            BrantaLogger.log(s: "Valid PrefHash. Deserializing.")
            do {
                let json = try JSONSerialization.data(withJSONObject: prefHash, options: [])
                if let str = String(data: json, encoding: .utf8) {
                    return str
                }
            } catch {
                BrantaLogger.log(s: "Error converting prefHash to JSON: \(error)")
            }
        } else {
            BrantaLogger.log(s: "PrefHash corrupted. Reseting.")
        }
        
        return ""
    }
}
