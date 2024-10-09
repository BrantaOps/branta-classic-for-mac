//
//  Whisper.swift
//  Branta
//
//  Created by Keith Gardner on 7/23/24.
//

import Cocoa
import Foundation

class Whisper {
    
    class func injectByName(name: String, showConfirmation: Bool = false) {
        let urlString = "https://whisper.branta.pro/listen?w=\(name)"
        
        guard let url = URL(string: urlString) else {
            BrantaLogger.log(s: "Error: Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                BrantaLogger.log(s: "Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                BrantaLogger.log(s: "Error: Invalid response")
                return
            }
            
            guard let data = data else {
                BrantaLogger.log(s: "Error: No data received or data is not in UTF-8 format")
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(WhisperData.self, from: data)
                BrantaLogger.log(s: "Decoded Response: \(responseData)")
                
                DispatchQueue.main.async {
                    if updateWhispers(with: responseData) && showConfirmation {
                        let alert = NSAlert()
                        alert.messageText = "Added Whisper from \(responseData.secret)"
                        alert.informativeText = "Message: \(responseData.message)"
                        alert.alertStyle = .warning
                        alert.addButton(withTitle: "OK")
                        alert.runModal()
                    }
                }
                
            } catch {
                BrantaLogger.log(s: "Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
    
    class func deleteByName(name: String) {
        if var savedWhispers = Settings.readFromDefaults()[Branta.Constants.Prefs.WHISPERS] as? [[String: Any]] {
            
            if savedWhispers.isEmpty {
                return
            } else {
                savedWhispers = savedWhispers.filter { whisper in
                    if let secret = whisper["secret"] as? String {
                        return secret != name
                    }
                    return true
                }
                Settings.set(key: Branta.Constants.Prefs.WHISPERS, value: savedWhispers)
                Whisper.notifyObservers()
            }
        }
    }
    
    private class func updateWhispers(with responseData: WhisperData) -> Bool {
        var savedWhispers = Settings.readFromDefaults()[Branta.Constants.Prefs.WHISPERS] as? [[String: Any]] ?? []
        
        let responseDict = responseData.toDictionary()
        
        if savedWhispers.isEmpty {
            Settings.set(key: Branta.Constants.Prefs.WHISPERS, value: [responseDict])
        } else {
            guard let newSecret = responseDict?["secret"] as? String else { return false }
            
            if !savedWhispers.contains(where: { ($0["secret"] as? String) == newSecret }) {
                savedWhispers.append(responseDict ?? [:])
                Settings.set(key: Branta.Constants.Prefs.WHISPERS, value: savedWhispers)
                Whisper.notifyObservers()
                return true
            }
        }
        return false
    }
}

// OBSERVER ------------------------------------------------------------------------------------------
extension Whisper {
    private static var observers = [WhisperObserver]()

    static func addObserver(_ observer: WhisperObserver) {
        observers.append(observer)
    }
    
    static func removeObserver(_ observer: WhisperObserver) {
        observers.removeAll { $0 === observer }
    }
    
    static func notifyObservers() {
        for observer in observers {
            observer.contentDidUpdate()
        }
    }
}
