//
//  AppVersion.swift
//  Branta
//
//  Created by Keith Gardner on 4/23/24.
//

import Foundation

class AppVersion {
    
    static func get(atPath appPath: String) -> String {
        let infoPlistPath = appPath + "/Contents/Info.plist"
        let key = "CFBundleShortVersionString"

        guard let infoDict = NSDictionary(contentsOfFile: infoPlistPath),
              let version = infoDict[key] as? String else {
            return "nil"
        }

        return version
    }

}
