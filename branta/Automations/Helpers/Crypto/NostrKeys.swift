import Foundation

//https://github.com/nostr-protocol/nips/blob/master/19.md

class NostrKeys {
    static let npubRegex = try! NSRegularExpression(pattern: "^npub[0-9a-z]{58,65}$", options: .caseInsensitive)
    static let nsecRegex = try! NSRegularExpression(pattern: "^nsec[0-9a-z]{58,65}$", options: .caseInsensitive)
    
    static func isPubKey(candidate: String) -> Bool {
        let range = NSRange(location: 0, length: candidate.utf16.count)
        
        return npubRegex.firstMatch(in: candidate, options: [], range: range) != nil
    }
    
    static func isPrivateKey(candidate: String) -> Bool {
        let range = NSRange(location: 0, length: candidate.utf16.count)
        
        return nsecRegex.firstMatch(in: candidate, options: [], range: range) != nil
    }
}
