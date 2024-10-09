//
//  LocalKeyScan.swift
//  Branta
//
//  Created by Keith Gardner on 7/11/24.
//

import BitcoinDevKit

class LocalKeyScan {
    
    public static let DEFAULT_WATCH_ONLY_FINGERPRINT = "00000000"
    private static var xpubs = Settings.readFromDefaults()[Branta.Constants.Prefs.XPUBS]
    
    static func perform(clipboardString: String) -> KeyScanResult {
        refreshKeys()
        
        guard let castedXpubs = xpubs as? [String:String] else {
            return KeyScanResult(keyName: "No Matching Key Found", match: false, derivationPath: "")
        }
        
        for (xpubName, xpubValue) in castedXpubs {
            do {
                let descriptorPublicKey     = try DescriptorPublicKey.fromString(publicKey: xpubValue)
                let fingerprint             = DEFAULT_WATCH_ONLY_FINGERPRINT
                // ???
                let keychainKind            = KeychainKind.external
                // TODO - params based on BrantaStruct for network.
                let network                 = Network.bitcoin
                // TODO - confirm this (nonpersistance)
                let dbConfig                = DatabaseConfig.memory

                // TODO - BIP44, BIP84, etc
                let desc                    = Descriptor.newBip84Public(
                    publicKey: descriptorPublicKey,
                    fingerprint: fingerprint,
                    keychain: keychainKind,
                    network: network)
                
                let wallet                  = try Wallet.init(
                    descriptor: desc,
                    changeDescriptor: nil,
                    network: network,
                    databaseConfig: dbConfig)
                
                if crawlAddresses(wallet: wallet, clipboardString: clipboardString) {
                    return KeyScanResult(keyName: xpubName, match: true, derivationPath: "")
                }
            } catch let error as DescriptorPublicKey {
                BrantaLogger.log(s: "LocalKeyScan.perform error: DescriptorPublicKey \(error)")
            }
            catch {
               BrantaLogger.log(s: "LocalKeyScan.perform error.")
           }
        }
        return KeyScanResult(keyName: "No Matching Key Found", match: false, derivationPath: "")
    }
    
    private
    
    // TODO - expand.
    static func crawlAddresses(wallet: Wallet, clipboardString: String) -> Bool {
        do {
            for i in 0...20 {
                BrantaLogger.log(s: i)
                let add = try wallet.getInternalAddress(addressIndex: AddressIndex.new)
                BrantaLogger.log(s: "bip44Wallet: \(add.address.asString())")
                if clipboardString == add.address.asString() {
                    return true
                }
            }
        } catch {
            BrantaLogger.log(s: "LocalKeyScan.crawlAddresses error.")
        }
        
        return false
    }
    
    static func refreshKeys() {
        xpubs = Settings.readFromDefaults()[Branta.Constants.Prefs.XPUBS]
    }
}
