//
//  WhisperData.swift
//  Branta
//
//  Created by Keith Gardner on 7/19/24.
//

import Foundation

struct WhisperData: Codable, Comparable {
    static func < (lhs: WhisperData, rhs: WhisperData) -> Bool {
        return lhs.secret < rhs.secret
    }
    
    static func == (lhs: WhisperData, rhs: WhisperData) -> Bool {
        return lhs.secret == rhs.secret
    }
    
    let id: Int
    let secret: String
    let message: String
    let expiry: String?
    let address: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case secret
        case message
        case expiry
        case address
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
              let dictionary = json as? [String: Any] else {
            return nil
        }
        return dictionary
    }
    
    static func fromDictionary(_ dictionary: [String: Any]) -> WhisperData? {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted),
              let whisper = try? JSONDecoder().decode(WhisperData.self, from: data) else {
            return nil
        }
        return whisper
    }
}
