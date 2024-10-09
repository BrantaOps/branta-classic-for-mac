import Foundation

class BitcoinAddress {
    static func isAddress(candidate: String) -> Bool {
        return isP2SH(candidate: candidate) ||  isP2PKH(candidate: candidate) || isSegwit(candidate: candidate)
    }
    
    static func isP2PKH(candidate: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[1][a-km-zA-HJ-NP-Z1-9]{25,34}$", options: .caseInsensitive)
        let range = NSRange(location: 0, length: candidate.utf16.count)
        return regex.firstMatch(in: candidate, options: [], range: range) != nil
    }
    
    static func isP2SH(candidate: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[3][a-km-zA-HJ-NP-Z1-9]{25,34}$", options: .caseInsensitive)
        let range = NSRange(location: 0, length: candidate.utf16.count)
        return regex.firstMatch(in: candidate, options: [], range: range) != nil
    }
    
    // P2WPKH, P2WSH, P2TR
    static func isSegwit(candidate: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^bc1[0-9a-zA-Z]{25,65}$", options: .caseInsensitive)
        let range = NSRange(location: 0, length: candidate.utf16.count)
        return regex.firstMatch(in: candidate, options: [], range: range) != nil
    }
    
    static func isTestnet(candidate: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^tb1[0-9a-zA-Z]{25,65}$", options: .caseInsensitive)
        let range = NSRange(location: 0, length: candidate.utf16.count)
        return regex.firstMatch(in: candidate, options: [], range: range) != nil
    }
}
