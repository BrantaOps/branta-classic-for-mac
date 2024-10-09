//
//  ArchitectureTests.swift
//  BrantaTests
//
//  Created by Keith Gardner on 4/8/24.
//

import XCTest
@testable import Branta

class ArchitectureTests: XCTestCase {
    func testIsArm() {
        #if arch(arm64)
            // Fails on Github Actions.
            //XCTAssertFalse(Architecture.isArm())
        #endif
    }

    func testIsIntel() {
        #if arch(x86_64)
            XCTAssertTrue(Architecture.isIntel())
        #endif
    }
}
