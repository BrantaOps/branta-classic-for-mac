//
//  ClipboardTests.swift
//  brantaTests
//
//  Created by Keith Gardner on 12/15/23.
//

import XCTest
@testable import Branta

class MockClipboardObserver: ClipboardObserver {
    public var contentDidChangeCalled = false
    var receivedContent: String?
    var receivedLabelText: String?
    
    func contentDidChange(clipboardDisplay: ClipboardDisplay) {
        contentDidChangeCalled = true
        receivedContent = "stub"
        receivedLabelText = "stub"
    }
}

class ClipboardTests: XCTestCase {
    var mockObserver = MockClipboardObserver()
    
    func testRunMethod() {
        XCTAssertNoThrow(Clipboard.run())
    }
    
    func testTyping() {
        XCTAssertTrue(Clipboard.isSubclass(of: BackgroundAutomation.self))
    }
    
    func testAddObserver() {
        XCTAssertNoThrow(Clipboard.addObserver(mockObserver))
    }
    
    func testNotifyObservers() {
         Clipboard.addObserver(mockObserver)
         Clipboard.notifyObservers()
         
         XCTAssertTrue(mockObserver.contentDidChangeCalled, "contentDidChange should be called on observer.")
         XCTAssertEqual(mockObserver.receivedContent, "stub", "Observer should receive correct content.")
         XCTAssertEqual(mockObserver.receivedLabelText, "stub", "Observer should receive correct labelText.")
     }
}
