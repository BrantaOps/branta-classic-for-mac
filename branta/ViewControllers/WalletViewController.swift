//
//  WalletViewController.swift
//  branta
//
//  Created by Keith Gardner on 12/22/23.
//

import Cocoa

class WalletViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var spinner: NSProgressIndicator!
    
    private var tableData: [CrawledWallet] = []
    
    private let COLUMNS = [
        "WALLET_NAME"           : 0,
        "LAST_SCANNED"          : 1
    ]
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.appearance = NSAppearance(named: .darkAqua)
        spinner.startAnimation(nil)
        adjustColumns()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate      = self
        tableView.dataSource    = self
        start()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()

        if let window = view.window {
            window.minSize = NSSize(width: 550, height: 320)
            window.titlebarAppearsTransparent = true
            window.title = ""
         }
    }
    
    @IBAction func help(_ sender: Any) {
        let url = URL(string: "https://docs.branta.pro/")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func showDetails(sender: NSClickGestureRecognizer) {
        
        if let clickedTextField = sender.view as? NSTextField {
            let row             = tableView.row(for: clickedTextField)
            let wallet          = tableData[row]
            let alert           = NSAlert()
            let name            = wallet.fullWalletName.replacingOccurrences(of: ".app", with: "")
            let version         = wallet.venderVersion
            let nameKey         = wallet.fullWalletName
            let hashes          = Bridge.getRuntimeHashes()[nameKey]!
            
            alert.messageText   = "\(name) \(version)"
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            
            if wallet.notFound {
                let localizedString = NSLocalizedString("TableNotFoundMessage", comment: "")
                alert.informativeText = String(format: localizedString, name)
            } else if wallet.brantaSignatureMatch {
                let localizedString = NSLocalizedString("TableVerifiedMessage", comment: "")
                alert.informativeText = String(format: localizedString, name)
            } else if !wallet.brantaSignatureMatch && hashes[version] != nil {
                alert.informativeText = NSLocalizedString("TableNotVerifiedMessage", comment: "")
            } else {
                if wallet.tooNew {
                    alert.informativeText = NSLocalizedString("TableVersionTooNewMessage", comment: "")
                }
                else if wallet.tooOld {
                    let localizedString = NSLocalizedString("TableVersionTooOldMessage", comment: "")
                    alert.informativeText = String(format: localizedString, name, name)
                }
                else {
                    alert.informativeText = NSLocalizedString("TableVersionNotSupportedMessage", comment: "")
                }
            }
            
            alert.beginSheetModal(for: self.view.window!)
        }
    }
}

extension WalletViewController: NSTableViewDelegate, NSTableViewDataSource {
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
        let textField = TextFieldWithHover()
        textField.identifier = NSUserInterfaceItemIdentifier("TextCell")
        textField.isEditable = false
        textField.bezelStyle = .roundedBezel
        textField.isBezeled = false
        textField.alignment = .center
        textField.font = NSFont(name: Branta.Constants.Ui.FONT_FAMILY, size: Branta.Constants.Ui.TABLE_FONT_SIZE)
        let name = tableData[row].fullWalletName.replacingOccurrences(of: ".app", with: "")
        
        if columnNumber == COLUMNS["WALLET_NAME"] {
            // TODO - this should show "Out of Date" without requiring clicks.
            if tableData[row].brantaSignatureMatch {
                let localizedString = NSLocalizedString("RowVerified", comment: "")
                textField.stringValue = String(format: localizedString, name)
            }
            else if tableData[row].notFound {
                let localizedString = NSLocalizedString("RowNotFound", comment: "")
                textField.stringValue = String(format: localizedString, name)
            }
            else {
                let localizedString = NSLocalizedString("RowNoMatch", comment: "")
                textField.stringValue = String(format: localizedString, name)
            }
            textField.toolTip = textField.stringValue
            let clickGesture            = NSClickGestureRecognizer(target: self, action: #selector(showDetails))
            textField.addGestureRecognizer(clickGesture)
        } else if columnNumber == COLUMNS["LAST_SCANNED"] {
            let currentTime         = Date()
            let dateFormatter       = DateFormatter()
            dateFormatter.timeStyle = .medium
            let formattedTime       = dateFormatter.string(from: currentTime)
            textField.stringValue   = formattedTime
            textField.toolTip       = formattedTime
            let clickGesture        = NSClickGestureRecognizer(target: self, action: #selector(showDetails))
            textField.addGestureRecognizer(clickGesture)
        }

        return textField
    }
}

extension WalletViewController: VerifyObserver {
    
    func verifyDidChange(newResults: [CrawledWallet]) {
        spinner.isHidden = true
        
        tableData = newResults
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension WalletViewController {
    private
    
    func start() {
        Bridge.fetchLatest { success in
            if success {
                Verify.addObserver(self)
                Verify.verify()
            } else {
                BrantaLogger.log(s: "WalletViewController; could not start `Verify.verify()`.")
            }
        }
    }
    
    func adjustColumns() {
        let columns = tableView.tableColumns
        let totalWidth = tableView.bounds.width
        let newColumnWidth = totalWidth / CGFloat(columns.count)
        
        for column in columns {
            column.width = newColumnWidth
            column.headerCell = BrantaTableHeaderCell(textCell: column.headerCell.stringValue)
        }
    }
}
