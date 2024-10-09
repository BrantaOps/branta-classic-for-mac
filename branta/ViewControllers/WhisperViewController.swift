//
//  WhisperViewController.swift
//  Branta
//
//  Created by Keith Gardner on 7/12/24.
//

import Cocoa

class WhisperViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var shareCodeTextField: NSTextField!
    private var tableData: [WhisperData] = []
    
    private let COLUMNS = [
        "SHARE_CODE"    : 0,
        "ADDRESS"       : 1,
        "COPY"          : 2,
        "DELETE"        : 3
    ]
    
    override func viewWillAppear() {
        super.viewWillAppear()
        Whisper.addObserver(self)
        self.view.window?.appearance = NSAppearance(named: .darkAqua)
        tableView.dataSource = self
        tableView.delegate = self
        
        updateTable()
        
        for column in tableView.tableColumns {
            column.headerCell = BrantaTableHeaderCell(textCell: column.headerCell.stringValue)
        }
    }
}

extension WhisperViewController {
    
    private
    
    func updateTable() {
        tableData = []
        if let savedWhispers = Settings.readFromDefaults()[Branta.Constants.Prefs.WHISPERS] as? [[String: Any]] {
            for s in savedWhispers {
                guard let w = WhisperData.fromDictionary(s) else { return }
                tableData.append(w)
            }
        }
        tableView.reloadData()
    }
}

extension WhisperViewController {
    @IBAction func create(_ sender: Any) {
        if let url = URL(string: Branta.Constants.Urls.WHISPER) {
            NSWorkspace.shared.open(url)
        }
    }

    @IBAction func help(_ sender: Any) {
        MenuHelper.openHelp()
    }
    
    @IBAction func getWhisper(_ sender: Any) {
        Whisper.injectByName(name: shareCodeTextField.stringValue)
    }
}

extension WhisperViewController {
    @objc func deleteWhisper(sender: NSClickGestureRecognizer) {
        if let clickedTextField = sender.view as? NSTextField {
            let row = tableView.row(for: clickedTextField)
            let whispers = Array(tableData).sorted()
            let whisper = whispers[row]
            
            let alert = NSAlert()
            alert.messageText = "Confirmation"
            alert.informativeText = "This will remove whisper: \"\(whisper.secret)\"."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Confirm")
            alert.addButton(withTitle: "Dismiss")
            
            let response = alert.runModal()
            
            if response == .alertFirstButtonReturn {
                Whisper.deleteByName(name: whisper.secret)
            }
        }
    }
    
    @objc func copyWhisper(sender: NSClickGestureRecognizer) {
        if let clickedTextField = sender.view as? NSTextField {
            let row = tableView.row(for: clickedTextField)
            
            let whispers = Array(tableData).sorted()
            let whisper = whispers[row]
            
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(whisper.address, forType: .string)
        }
    }
}

extension WhisperViewController: NSTableViewDelegate, NSTableViewDataSource {
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
        
        let whispers = Array(tableData).sorted()
        let whisper = whispers[row]
        
        if columnNumber == COLUMNS["SHARE_CODE"] {
            if whisper.message.count > 0 {
                textField.stringValue = "\(whisper.secret) (\(whisper.message))"
                textField.toolTip = "\(whisper.secret) (\(whisper.message))"
            } else {
                textField.stringValue = "\(whisper.secret)"
                textField.toolTip = "\(whisper.secret)"
            }

            if let cell = textField.cell as? NSTextFieldCell {
                cell.lineBreakMode = .byTruncatingTail
            }
        } else if columnNumber == COLUMNS["ADDRESS"] {
            textField.stringValue = whisper.address
            textField.toolTip = whisper.address
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
            let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(copyWhisper))
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
            let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(deleteWhisper))
            textField.addGestureRecognizer(clickGesture)
            return textField
        }
        return textField
    }
}

extension WhisperViewController: WhisperObserver {
    func contentDidUpdate() {
        updateTable()
    }
}
