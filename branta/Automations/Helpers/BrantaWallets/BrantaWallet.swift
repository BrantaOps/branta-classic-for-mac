//
//  BrantaWallet.swift
//  branta
//
//  Created by Keith Gardner on 11/17/23.
//
//

import Foundation

class BrantaWallet: Equatable {
    
    static func == (lhs: BrantaWallet, rhs: BrantaWallet) -> Bool {
        return false
    }
    
    // Name in motion
    // (Grep all PIDs by this string to find child PIDS)
    // (If there are exceptions to this, subclass)
    class func runtimeName() -> String {
        return "Implement me"
    }
    
    // Name at Rest
    class func name() -> String {
        return "Implement me.app"
    }
    
    class func singleBinary() -> Bool {
        return false
    }
    
    // For network tab. This is the string that shows in the dock.
    class func localizedName() -> String {
        return runtimeName()
    }
    
    class func getCls(forStr: String) -> BrantaWallet {
        if forStr == Sparrow.name() {
            return Sparrow()
        }
        else if forStr == BitcoinCore.name() {
            return BitcoinCore()
        }
        
        return BrantaWallet()
    }
}
