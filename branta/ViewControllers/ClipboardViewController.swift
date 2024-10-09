//
//  ClipboardViewController.swift
//  Branta
//
//  Created by Keith Gardner on 7/12/24.
//

import Cocoa

class ClipboardViewController: NSViewController {
    @IBOutlet weak var clipboardLabel: NSTextField!
    
    @IBOutlet weak var addressOrKeyPrefix: NSTextField!
    @IBOutlet weak var walletNamePrefix: NSTextField!
    @IBOutlet weak var whisperNamePrefix: NSTextField!
    @IBOutlet weak var whisperMessagePrefix: NSTextField!
    
    @IBOutlet weak var addressOrKey: NSTextField!
    @IBOutlet weak var walletName: NSTextField!
    @IBOutlet weak var whisperName: NSTextField!
    @IBOutlet weak var whisperMessage: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Clipboard.addObserver(self)
        addressOrKey.toolTip = addressOrKey.stringValue
        
    }
    
    @IBAction func help(_ sender: Any) {
        MenuHelper.openHelp()
    }
}

extension ClipboardViewController: ClipboardObserver {
    func contentDidChange(clipboardDisplay: ClipboardDisplay) {
        clipboardLabel.stringValue = clipboardDisplay.label
        
        if clipboardDisplay.key != "" {
            addressOrKeyPrefix.stringValue = "Public Key:"
            addressOrKey.stringValue = clipboardDisplay.key
            addressOrKey.toolTip = addressOrKey.stringValue
            
            walletNamePrefix.isHidden = true
            whisperNamePrefix.isHidden = true
            whisperMessagePrefix.isHidden = true
        }
        else if clipboardDisplay.address != "" {
            addressOrKeyPrefix.stringValue = "Address:"
            addressOrKey.stringValue = clipboardDisplay.address
            addressOrKey.toolTip = addressOrKey.stringValue
            
            walletNamePrefix.isHidden = false
            whisperNamePrefix.isHidden = false
            whisperMessagePrefix.isHidden = false
        }
        else {
            addressOrKey.stringValue = ""
            addressOrKey.toolTip = ""
        }

        
        walletName.stringValue = clipboardDisplay.walletName
        whisperName.stringValue = clipboardDisplay.whisperSecret
        whisperMessage.stringValue = clipboardDisplay.whisperMessage
    }
}
