//
//  BrantaTableHeaderCell.swift
//  Branta
//
//  Created by Keith Gardner on 7/7/24.
//

import Cocoa

class BrantaTableHeaderCell: NSTableHeaderCell {
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {

        let font = NSFont(name: Branta.Constants.Ui.FONT_FAMILY, size: Branta.Constants.Ui.TABLE_FONT_SIZE)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.labelColor
        ]
        
        let attributedString = NSAttributedString(string: self.stringValue, attributes: attributes)
        
        let textRect = attributedString.boundingRect(with: cellFrame.size, options: .usesLineFragmentOrigin)
        let textPoint = NSPoint(
            x: cellFrame.midX - textRect.width / 2,
            y: cellFrame.midY - textRect.height / 2
        )
        attributedString.draw(at: textPoint)
    }
    
    override func drawSortIndicator(withFrame cellFrame: NSRect, in controlView: NSView, ascending: Bool, priority: Int) {
        super.drawSortIndicator(withFrame: cellFrame, in: controlView, ascending: ascending, priority: priority)
    }
}
