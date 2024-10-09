//
//  TabViewController.swift
//  Branta
//
//  Created by Keith Gardner on 7/15/24.
//

import Cocoa

class TabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func selectTab(at index: Int) {
        guard index >= 0 && index < tabViewItems.count else {
            print("Invalid tab index")
            return
        }
        
        selectedTabViewItemIndex = index
    }
}
