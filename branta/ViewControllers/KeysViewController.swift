//
//  KeysViewController.swift
//  Branta
//
//  Created by Keith Gardner on 6/24/24.
//

import Cocoa

class KeysViewController: NSViewController {
    private var tableData: [String:String] = [:]
    
    @IBOutlet weak var tableView: NSTableView!
    
    private let COLUMNS = [
        "NAME"              : 0,
        "XPUB"              : 1,
        "COPY"              : 2,
        "DELETE"            : 3,
    ]
    
    override func viewWillAppear() {
        super.viewWillAppear()
        AddKeyViewController.addObserver(self)
        self.view.window?.appearance = NSAppearance(named: .darkAqua)
        self.title = ""
        for column in tableView.tableColumns {
            column.headerCell = BrantaTableHeaderCell(textCell: column.headerCell.stringValue)
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
                
        if let window = view.window {
            window.titlebarAppearsTransparent = true
            window.title = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let pref = Settings.readFromDefaults()
        tableData = pref[Branta.Constants.Prefs.XPUBS] as? [String:String] ?? [:]
        
        tableView.delegate      = self
        tableView.dataSource    = self
    }

    @IBAction func newKeys(_ sender: Any) {
        let appDelegate = NSApp.delegate as? AppDelegate
        
        if appDelegate?.newKeyWindow != nil {
            appDelegate?.newKeyWindow?.makeKeyAndOrderFront(nil)
            appDelegate?.newKeyWindow?.center()
            return
        }
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateController(withIdentifier: "newKeyWindow") as! AddKeyViewController
        let window = NSWindow(contentViewController: viewController)

        appDelegate?.newKeyWindow = window
        window.makeKeyAndOrderFront(nil)
        window.center()
    }
    
    @objc func copyXPub(sender: NSClickGestureRecognizer) {
        if let clickedTextField = sender.view as? NSTextField {
            let row = tableView.row(for: clickedTextField)
            BrantaLogger.log(s: "Copying \(row)")
            
            let keys = Array(tableData.values).sorted()
            let key = keys[row]
            BrantaLogger.log(s: "Copying \(key)")

            
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(key, forType: .string)
        }
    }
    
    @objc func deleteXPub(sender: NSClickGestureRecognizer) {

        if let clickedTextField = sender.view as? NSTextField {
            let row = tableView.row(for: clickedTextField)
            let keys = Array(tableData.keys).sorted()
            let key = keys[row]
            
            let alert = NSAlert()
            alert.messageText = "Confirmation"
            alert.informativeText = "This will remove the key labeled \"\(key)\" and cannot be undone."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Confirm")
            alert.addButton(withTitle: "Dismiss")
            
            let response = alert.runModal()
            
            if response == .alertFirstButtonReturn {                
                let pref = Settings.readFromDefaults()
                var xpubs = pref[Branta.Constants.Prefs.XPUBS] as? [String:String] ?? [:]
                xpubs.removeValue(forKey: key)
                
                Settings.set(key: Branta.Constants.Prefs.XPUBS, value: xpubs)
                
                tableData = xpubs
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func help(_ sender: Any) {
        MenuHelper.openHelp()
    }
    
}

extension KeysViewController: KeysObserver {
    func contentDidUpdate() {
        let pref = Settings.readFromDefaults()
        tableData = pref[Branta.Constants.Prefs.XPUBS] as? [String:String] ?? [:]
        tableView.reloadData()
    }
}

extension KeysViewController: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return Branta.Constants.Ui.HEIGHT
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let columnNumber = tableView.tableColumns.firstIndex(of: tableColumn!) else {
            return nil
        }
        
        // Force rewrite of the table. Don't care about cache.
        let textField = NSTextField()
        textField.identifier = NSUserInterfaceItemIdentifier("TextCell")
        textField.isEditable = false
        textField.bezelStyle = .roundedBezel
        textField.isBezeled = false
        textField.alignment = .center
        textField.font = NSFont(name: Branta.Constants.Ui.FONT_FAMILY, size: Branta.Constants.Ui.TABLE_FONT_SIZE)
        
        let keys = Array(tableData.keys).sorted()
        let key = keys[row]
        let value = tableData[key] ?? ""
        
        if columnNumber == COLUMNS["NAME"] {
            textField.stringValue = key
            textField.toolTip = key
            if let cell = textField.cell as? NSTextFieldCell {
                cell.lineBreakMode = .byTruncatingTail
            }
        } else if columnNumber == COLUMNS["XPUB"] {
            textField.stringValue = value
            textField.toolTip = value
            if let cell = textField.cell as? NSTextFieldCell {
                cell.lineBreakMode = .byTruncatingTail
            }
        } else if columnNumber == COLUMNS["COPY"] {
            let textField = TextFieldWithHover()
            textField.identifier = NSUserInterfaceItemIdentifier("TextCell")
            textField.isEditable = false
            textField.bezelStyle = .roundedBezel
            textField.isBezeled = false
            textField.alignment = .center
            textField.font = NSFont(name: Branta.Constants.Ui.FONT_FAMILY, size: Branta.Constants.Ui.TABLE_FONT_SIZE)
            textField.stringValue = "⧉"
            textField.toolTip = "Copy"
            let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(copyXPub))
            textField.addGestureRecognizer(clickGesture)
            return textField
        } else if columnNumber == COLUMNS["DELETE"] {
            let textField = TextFieldWithHover()
            textField.identifier = NSUserInterfaceItemIdentifier("TextCell")
            textField.isEditable = false
            textField.bezelStyle = .roundedBezel
            textField.isBezeled = false
            textField.alignment = .center
            textField.font = NSFont(name: Branta.Constants.Ui.FONT_FAMILY, size: Branta.Constants.Ui.TABLE_FONT_SIZE)
            textField.textColor = NSColor(hex: Branta.Constants.Ui.RED)
            textField.stringValue = "✕"
            textField.toolTip = "Delete"
            let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(deleteXPub))
            textField.addGestureRecognizer(clickGesture)
            return textField
        }
        return textField
    }
}
