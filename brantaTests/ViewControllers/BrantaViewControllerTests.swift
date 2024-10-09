//
//  BrantaViewControllerTests.swift
//  BrantaTests
//
//  Created by Keith Gardner on 1/12/24.
//


import XCTest
@testable import Branta

class BrantaViewControllerTests: XCTestCase {

    func testDelegates() {
        let brantaViewController = WalletViewController()
        XCTAssertTrue(brantaViewController is NSViewController, "WalletViewController should conform to NSViewController")
        XCTAssertTrue(brantaViewController is VerifyObserver, "WalletViewController should conform to VerifyObserver")
        XCTAssertTrue(brantaViewController is NSTableViewDelegate, "WalletViewController should conform to NSTableViewDelegate")
        XCTAssertTrue(brantaViewController is NSTableViewDataSource, "WalletViewController should conform to NSTableViewDataSource")
    }
}
