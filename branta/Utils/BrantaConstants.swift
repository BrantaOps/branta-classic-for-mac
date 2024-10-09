//
//  BrantaConstants.swift
//  Branta
//
//  Created by Keith Gardner on 4/6/24.
//

import Foundation

struct Branta {
    struct Constants {
        struct Ui {
            static let HEIGHT = 30.0
            static let TABLE_FONT_SIZE = 20.0
            static let FONT_FAMILY = "Avenir"
            static let RED = "#944545"
            static let GRAY = "#333130"
            static let GRAY_FONT = "#AAAAAA"
        }
        
        struct Alias {
            typealias RuntimeHashType       = [String: [String:String]]
            typealias InstallerHashType     = [String:String]
        }
        
        struct Notify {
            static let FOR_BTC_ADDRESS          = "notifyForBTCAddress"
            static let FOR_SEED                 = "notifyForSeed"
            static let FOR_XPUB                 = "notifyForXPub"
            static let FOR_XPRV                 = "notifyForXPrv"
            static let FOR_NPUB                 = "notifyForNPub"
            static let FOR_NSEC                 = "notifyForNSec"
            static let UPON_LAUNCH              = "notifyUponLaunch"
            static let UPON_STATUS_CHANGE       = "notifyUponStatusChange"
        }
        
        struct Prefs {
            static let KEY                             = "Branta_Prefs"
            static let SCAN_CADENCE                    = "scanCadence"
            static let SCAN_CADENCE_WORDING            = "scanCadenceWording"
            static let DEFAULT_SCAN_CADENCE            = 30.0
            static let DEFAULT_SCAN_CADENCE_WORDING    = "30 Seconds"
            static let SHOW_IN_DOCK                    = "showInDock"
            static let XPUBS                           = "xpubs"
            static let WHISPERS                        = "whispers"
            static let LAST_SYNC                       = "lastSync"
            static let CADENCE_OPTIONS: [(String, Int)] = [
                ("1 Second", 1),
                ("5 Seconds", 5),
                ("10 Seconds", 10),
                ("30 Seconds", 30),
                ("60 Seconds", 60),
                ("5 Minutes", 300),
                ("10 Minutes", 600),
                ("30 Minutes", 1800)
            ]
        }
        

        
        struct Shortcut {
            static let CLIPBOARD       = "C"
            static let WALLETS         = "W"
            static let KEYS            = "K"
            static let WHISPER         = "H"
            static let SETTINGS        = "S"
            static let QUIT            = "Q"
            static let UPDATE          = "U"
            static let HELP            = "H"
        }
        
        struct KeyCodes {
            static let COMMA = 43
            static let K = 40
        }
        
        struct Urls {
            static let FETCH = "https://api.github.com/repos/brantaops/branta-mac/releases/latest"
            static let APP_STORE = "https://apps.apple.com/us/app/branta/id6473867474"
            static let WHISPER = "https://whisper.branta.pro/"
        }
        
        struct Wallets {
            static let NAMES = [Sparrow.name(), BitcoinCore.name()]
            static let RUNTIME_NAMES = [Sparrow.runtimeName(), BitcoinCore.runtimeName()]
        }
        
        struct Tabs {
            static let CLIPBOARD = 0
            static let WALLETS = 1
            static let KEYS = 2
            static let WHISPER = 3
            static let SETTINGS = 4
        }
        
        struct Misc {
            static let API_CADENCE = 1800.00
            static let CLIPBOARD_INTERVAL  = 0.5
            static let SEED_WORDS_MIN = 10
            static let SEED_WORDS_MAX = 26
            static let ACTIVE = "Status: Active ✓"
            static let WRONG_PASSWORD = "Incorrect Password"
        }
    }
}
