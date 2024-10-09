//
//  NostrKeysTests.swift
//  BrantaTests
//
//  Created by Keith Gardner on 7/16/24.
//

import XCTest
@testable import Branta

class NostrKeysTests: XCTestCase {
    
    func testIsPubKey() {
        XCTAssertTrue(NostrKeys.isPubKey(candidate: "npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyjh6w6"))
        XCTAssertTrue(NostrKeys.isPubKey(candidate: "npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyj1111"))
        
        XCTAssertFalse(NostrKeys.isPubKey(candidate: "npubkwsyjh6w6"))
        XCTAssertFalse(NostrKeys.isPubKey(candidate: "npubkwsyjh6w61111111111111111111111"))
        XCTAssertFalse(NostrKeys.isPubKey(candidate: "npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyj1111+"))
        XCTAssertFalse(NostrKeys.isPubKey(candidate: "npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyj1111  "))
        XCTAssertFalse(NostrKeys.isPubKey(candidate: "npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyj1111_"))
        XCTAssertFalse(NostrKeys.isPubKey(candidate: "_npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyj1111"))
        XCTAssertFalse(NostrKeys.isPubKey(candidate: "/npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyj1111"))
        XCTAssertFalse(NostrKeys.isPubKey(candidate: "npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyj1111/"))
        XCTAssertFalse(NostrKeys.isPubKey(candidate: "npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7*l8j4s3evf6u64th6gkwsyj1111"))
        XCTAssertFalse(NostrKeys.isPubKey(candidate: "npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7+l8j4s3evf6u64th6gkwsyj1111"))
        XCTAssertFalse(NostrKeys.isPubKey(candidate: "npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7(Al8j4s3evf6u64th6gkwsyj1111"))
    }
    
    func testIsPrivateKey() {
        XCTAssertTrue(NostrKeys.isPrivateKey(candidate: "nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5"))
        XCTAssertTrue(NostrKeys.isPrivateKey(candidate: "nsec1vl029mgpspedva04g90vltkh6fvh240zadsfk0t9af8935ke9laqsnlfe5"))
        
        XCTAssertFalse(NostrKeys.isPrivateKey(candidate: "nsec"))
        XCTAssertFalse(NostrKeys.isPrivateKey(candidate: "nsec123"))
        XCTAssertFalse(NostrKeys.isPrivateKey(candidate: "nsec123333333333333333"))
        XCTAssertFalse(NostrKeys.isPrivateKey(candidate: "nsec123333333333333333444444444444444444444444"))
        XCTAssertFalse(NostrKeys.isPrivateKey(candidate: " nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5"))
        XCTAssertFalse(NostrKeys.isPrivateKey(candidate: " nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5 "))
        XCTAssertFalse(NostrKeys.isPrivateKey(candidate: "nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5."))
        XCTAssertFalse(NostrKeys.isPrivateKey(candidate: ".nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5"))
        XCTAssertFalse(NostrKeys.isPrivateKey(candidate: "nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe+5"))
        XCTAssertFalse(NostrKeys.isPrivateKey(candidate: "nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5 nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5"))
        XCTAssertFalse(NostrKeys.isPrivateKey(candidate: "+nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe+5"))
    }
}
