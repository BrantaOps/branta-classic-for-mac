//
//  BitcoinKeys.swift
//  Branta
//
//  Created by Keith Gardner on 7/16/24.
//

import Foundation

class BitcoinKeys {
    static func isPubKey(candidate: String) -> Bool {
        return isBIP32PubKey(candidate: candidate) || isBIP49PubKey(candidate: candidate) || isBIP84PubKey(candidate: candidate)
    }

    static func isBIP32PubKey(candidate: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(xpub)[1-9A-HJ-NP-Za-km-z]{79,108}$")
        let range = NSRange(location: 0, length: candidate.utf16.count)
        return regex.firstMatch(in: candidate, options: [], range: range) != nil
    }
    
    static func isBIP49PubKey(candidate: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(ypub)[1-9A-HJ-NP-Za-km-z]{79,108}$")
        let range = NSRange(location: 0, length: candidate.utf16.count)
        return regex.firstMatch(in: candidate, options: [], range: range) != nil
    }
    
    static func isBIP84PubKey(candidate: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(zpub)[1-9A-HJ-NP-Za-km-z]{79,108}$")

        let range = NSRange(location: 0, length: candidate.utf16.count)
        return regex.firstMatch(in: candidate, options: [], range: range) != nil
    }
    
    static func isPrivateKey(candidate: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^xprv[0-9A-Za-z]{107}$")
        let range = NSRange(location: 0, length: candidate.utf16.count)
        return regex.firstMatch(in: candidate, options: [], range: range) != nil
    }
}
