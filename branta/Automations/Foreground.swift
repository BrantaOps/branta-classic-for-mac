//
//  Foreground.swift
//  Branta
//
//  Created by Keith Gardner on 1/15/24.
//

import Cocoa

class Foreground: BackgroundAutomation {
    
    private static var currentApp = ""
    private static var alreadyAlerted = ""
    private static let appDelegate = NSApp.delegate as? AppDelegate
    
    override class func run() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            checkForeground()
        }
    }
    
    private
    
    static func checkForeground() {
        currentApp = getForegroundApplication()
        if Branta.Constants.Wallets.RUNTIME_NAMES.contains(currentApp) {
            alertFor(app: currentApp)
        }
        else {
            alreadyAlerted = ""
        }
    }
    
    static func getForegroundApplication() -> String {
        if let app = NSWorkspace.shared.frontmostApplication {
            return app.localizedName!
        }
        return ""
    }
        
    static func alertFor(app: String) {
        if (app == alreadyAlerted) { return }
        
        if checkStatus(wallet: app) {
            appDelegate?.notificationManager?.showNotification(
                title: "\(app) Verified.",
                body: "",
                key: Branta.Constants.Notify.UPON_LAUNCH
            )
        } else {
            appDelegate?.notificationManager?.showNotification(
                title: "\(app) - No Match Found",
                body: "This could be for a number of reasons. Read more.",
                key: Branta.Constants.Notify.UPON_LAUNCH
            )
        }
        
        alreadyAlerted = app
    }
    
    static func checkStatus(wallet: String) -> Bool {
        return Matcher.checkRuntime(
            hash: Sha.sha256ForDirectory(atPath: "/Applications/" + wallet + ".app"),
            wallet: "\(wallet).app"
        )
    }
}
