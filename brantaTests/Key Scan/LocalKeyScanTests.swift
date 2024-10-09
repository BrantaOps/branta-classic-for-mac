//
//  LocalKeyScanTests.swift
//  BrantaTests
//
//  Created by Keith Gardner on 7/11/24.
//
import Foundation

import XCTest
@testable import Branta

class LocalKeyScanTests: XCTestCase {
    let miss = KeyScanResult(keyName: "No Matching Key Found", match: false, derivationPath: "")
    let hit = KeyScanResult(keyName: "foo", match: true, derivationPath: "")
    let keys = ["foo": "xpub6D3adHqLvy1TNBCcdMRCwG5HRYiMnujkWWbL3MprSwjVwnGPY2EdD5J2iF5XiTBNWj9eFAZdAP4LEZmBy2UAcZNeV9PtPgQXRnX5ecsGEC1"]

    // BIP84
    // m/84'/0'/0'
    func testP2WPKHMatch() {
        Settings.set(key: Branta.Constants.Prefs.XPUBS, value: keys)

        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "bc1qhk3p7mpgyka5aqu0yzs66nm3mxxyf97ud0gzdw"), hit, "../0/0")
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "bc1q845xqn34hsmh344ajn2r84mcgl6m0863p89jmr"), hit, "../0/15")
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "bc1qy4l8ccq43udzw8j792m7nnsmgjemd30mwcmz6g"), hit, "../0/19")
                
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: ""), miss)
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "."), miss)
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "abc"), miss)
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2"), miss)
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "3EktnHQD7RiAE6uzMj2ZifT9YgRrkSgzQX"), miss)
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "bc1qxp78h48nre66s2m529ey3u8lt39hesjveqtkap"), miss)
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "bc1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3qccfmv3"), miss)
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "xpub6D3adHqLvy1TNBCcdMRCwG5HRYiMnujkWWbL3MprSwjVwnGPY2EdD5J2iF5XiTBNWj9eFAZdAP4LEZmBy2UAcZNeV9PtPgQXRnX5ecsGEC1"), miss)
    }
    
    func testWithoutKeys() {
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: ""), miss)
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "."), miss)
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "abc"), miss)
        
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2"), miss, "P2PKH")
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "3EktnHQD7RiAE6uzMj2ZifT9YgRrkSgzQX"), miss, "P2SH")
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "bc1qxp78h48nre66s2m529ey3u8lt39hesjveqtkap"), miss, "P2WPKH")
        XCTAssertEqual(LocalKeyScan.perform(clipboardString: "bc1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3qccfmv3"), miss, "P2WSH / P2TR")
    }
    
    func testNoThrowWithBadInput() {
        XCTAssertNoThrow(LocalKeyScan.perform(clipboardString: ""))
        XCTAssertNoThrow(LocalKeyScan.perform(clipboardString: "."))
        XCTAssertNoThrow(LocalKeyScan.perform(clipboardString: "abc"))
        XCTAssertNoThrow(LocalKeyScan.perform(clipboardString: "bc1qxp78h48nre66s2m529ey3u8lt39hesjveqtkap"))
    }
}
