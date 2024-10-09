//
//  Clipboard.swift
//  branta
//
//  Created by Keith Gardner on 11/20/23.
//

import Cocoa

struct ClipboardDisplay {
    var label: String
    var address: String
    var key: String
    var walletName: String
    var whisperSecret: String
    var whisperMessage: String
    
    var alertTitle: String
    var alertBody: String
}

class Clipboard: BackgroundAutomation {
    
    private static var bip39WordSet : Set<String>?
    private static let appDelegate = NSApp.delegate as? AppDelegate
    private static var lastContent: String = ""
    private static var clipboardDisplay: ClipboardDisplay = ClipboardDisplay(
        label: "",
        address: "",
        key: "",
        walletName: "",
        whisperSecret: "",
        whisperMessage: "",
        alertTitle: "",
        alertBody: ""
    ) { didSet { notifyObservers() } }
    
    override class func run() {
        setup()
        
        Timer.scheduledTimer(withTimeInterval: Branta.Constants.Misc.CLIPBOARD_INTERVAL, repeats: true) { _ in
            guard let clipboardString = NSPasteboard.general.string(forType: .string),
                  clipboardString != lastContent else {
                return
            }
            
            lastContent = clipboardString
            
            if BitcoinAddress.isAddress(candidate: clipboardString) {
                getAddressDisplay(content: clipboardString)
                
                appDelegate?.notificationManager?.showNotification(
                    title: clipboardDisplay.alertTitle,
                    body: clipboardDisplay.alertBody,
                    key: Branta.Constants.Notify.FOR_BTC_ADDRESS
                )
            }
            else if BitcoinKeys.isPubKey(candidate: clipboardString) {
                clipboardDisplay = ClipboardDisplay(
                    label: "Clipboard",
                    address: "",
                    key: clipboardString,
                    walletName: "",
                    whisperSecret: "",
                    whisperMessage: "",
                    alertTitle: "Bitcoin Extended Public Key in Clipboard.",
                    alertBody: "Sharing can lead to loss of privacy."
                )
                appDelegate?.notificationManager?.showNotification(
                    title: clipboardDisplay.alertTitle,
                    body: clipboardDisplay.alertBody,
                    key: Branta.Constants.Notify.FOR_XPUB
                )
            }
            else if NostrKeys.isPubKey(candidate: clipboardString) {
                clipboardDisplay = ClipboardDisplay(
                    label: "Clipboard",
                    address: "",
                    key: clipboardString,
                    walletName: "",
                    whisperSecret: "",
                    whisperMessage: "",
                    alertTitle: "Nostr Public Key in Clipboard.",
                    alertBody: "Sharing can lead to loss of privacy."
                )
                appDelegate?.notificationManager?.showNotification(
                    title: clipboardDisplay.alertTitle,
                    body: "",
                    key: Branta.Constants.Notify.FOR_NPUB
                )
            }
            else if NostrKeys.isPrivateKey(candidate: clipboardString) {
                clipboardDisplay = ClipboardDisplay(
                    label: "Clipboard: Nsec detected.",
                    address: "",
                    key: "",
                    walletName: "",
                    whisperSecret: "",
                    whisperMessage: "",
                    alertTitle: "",
                    alertBody: ""
                )
                appDelegate?.notificationManager?.showNotification(
                    title: "Nostr Private Key in Clipboard.",
                    body: "Never share this.",
                    key: Branta.Constants.Notify.FOR_NSEC
                )
            }
            else if checkSeedPhraseAndNotify(candidate: clipboardString) {
                clipboardDisplay = ClipboardDisplay(
                    label: "Clipboard: Seed phrase detected.",
                    address: "",
                    key: "",
                    walletName: "",
                    whisperSecret: "",
                    whisperMessage: "",
                    alertTitle: "",
                    alertBody: ""
                )
            }
            else if BitcoinKeys.isPrivateKey(candidate: clipboardString) {
                clipboardDisplay = ClipboardDisplay(
                    label: "Clipboard: Bitcoin Private Key detected.",
                    address: "",
                    key: "",
                    walletName: "",
                    whisperSecret: "",
                    whisperMessage: "",
                    alertTitle: "",
                    alertBody: ""
                )
                appDelegate?.notificationManager?.showNotification(
                    title: "Bitcoin Private Key in Clipboard.",
                    body: "Never share this.",
                    key: Branta.Constants.Notify.FOR_XPRV
                )
            }
            else if BitcoinAddress.isTestnet(candidate: clipboardString) {
                clipboardDisplay = ClipboardDisplay(
                    label: "Clipboard",
                    address: clipboardString,
                    key: "",
                    walletName: "",
                    whisperSecret: "",
                    whisperMessage: "",
                    alertTitle: "",
                    alertBody: ""
                )
                appDelegate?.notificationManager?.showNotification(
                    title: "New Bitcoin Address in Clipboard.",
                    body: "Testnet.",
                    key: Branta.Constants.Notify.FOR_BTC_ADDRESS
                )
            }
            else {
                clipboardDisplay = ClipboardDisplay(
                    label: "Clipboard",
                    address: "",
                    key: "",
                    walletName: "",
                    whisperSecret: "",
                    whisperMessage: "",
                    alertTitle: "",
                    alertBody: ""
                )
            }
        }
    }
}

extension Clipboard {
    private static var observers = [ClipboardObserver]()

    static func addObserver(_ observer: ClipboardObserver) {
        observers.append(observer)
    }
    
    static func removeObserver(_ observer: ClipboardObserver) {
        observers.removeAll { $0 === observer }
    }
    
    static func notifyObservers() {
        for observer in observers {
            observer.contentDidChange(clipboardDisplay: clipboardDisplay)
        }
    }
}

extension Clipboard {
    private
    
    static func setup() {
        let path = Bundle.main.path(forResource: "bip39wordlist", ofType: "txt")
        let words = try? String(contentsOfFile: path!)
        bip39WordSet = Set(words!.components(separatedBy: "\n"))
    }
    
    static func getAddressDisplay(content:String) {
        
        // Match Whispers
        if let whispers = Settings.readFromDefaults()[Branta.Constants.Prefs.WHISPERS] as? [[String: Any]] {
            for w in whispers {
                let whisper = WhisperData.fromDictionary(w)
                if whisper?.address == content {
                    clipboardDisplay = ClipboardDisplay(
                        label: "Clipboard",
                        address: content,
                        key: "",
                        walletName: "",
                        whisperSecret: whisper!.secret,
                        whisperMessage: whisper!.message,
                        alertTitle: "Note: \(whisper!.message)",
                        alertBody: "New Bitcoin Address in Clipboard."
                    )
                    return
                }
            }
        }
        let scanResult = LocalKeyScan.perform(clipboardString: content)
        if scanResult.match {
            clipboardDisplay =  ClipboardDisplay(
                label: "Clipboard",
                address: content,
                key: "",
                walletName: scanResult.keyName,
                whisperSecret: "",
                whisperMessage: "",
                alertTitle: "Bitcoin address detected from \(scanResult.keyName).",
                alertBody: "Belongs to \(scanResult.keyName)."
            )
        } else {
            clipboardDisplay = ClipboardDisplay(
                label: "Clipboard",
                address: content,
                key: "",
                walletName: "",
                whisperSecret: "",
                whisperMessage: "",
                alertTitle: "New Bitcoin Address in Clipboard.",
                alertBody: "No known wallets."
            )
        }
    }
    
    // TODO - Extract.
    // We can have a reverse clipboard sweeper than deletes a seed from clipboard.
    static func checkSeedPhraseAndNotify(candidate:String) -> Bool {
        let hasWhitespace = candidate.rangeOfCharacter(from: .whitespacesAndNewlines)

        // Must have space or newlines between seed words
        if hasWhitespace == nil {
            return false
        }
        
        // Naive, but check that each item is a BIP39.
        let spaced = candidate.components(separatedBy: " ")
        let newlined = candidate.components(separatedBy: "\n")
        var userSeedWords: Set<String> = []
        
        // Deduce seedwords from \n or " "
        if (spaced.count > newlined.count) {
            userSeedWords = Set(spaced)
        }
        else if (newlined.count > spaced.count){
            userSeedWords = Set(newlined)
        }
        
        // TODO - case this case, the line broke, its a valid seed with \n on a line. Strip each word of \n.
//        ["actor", "absent", "absurd", "across", "actress", "acquire", "absorb", "accident", "action", "abandon", "accuse", "able", "actual\n", "abuse", "act", "account", "above", "acoustic", "access", "about", "achieve", "abstract", "acid", "ability"]
        
        // Check quantity
        if (userSeedWords.count < Branta.Constants.Misc.SEED_WORDS_MIN || userSeedWords.count > Branta.Constants.Misc.SEED_WORDS_MAX) {
            return false
        }
        
        if (userSeedWords.isSubset(of: bip39WordSet!)) {
            appDelegate?.notificationManager?.showNotification(
                title: "Seed phrase detected in clipboard.",
                body: "Never share this.",
                key: Branta.Constants.Notify.FOR_SEED
            )
            return true
        }
        return false
    }
}
