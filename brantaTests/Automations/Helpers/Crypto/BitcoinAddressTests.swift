//
//  BitcoinAddressTests.swift
//  BrantaTests
//
//  Created by Keith Gardner on 7/16/24.
//

import XCTest
@testable import Branta

class BitcoinAddressTests: XCTestCase {
    
    func testDirectAddressCalls() {
        XCTAssertTrue(BitcoinAddress.isP2PKH(candidate: "1LMcKyPmwebfygoeZP8E9jAMS2BcgH3Yip"))
        XCTAssertTrue(BitcoinAddress.isP2SH(candidate: "3EktnHQD7RiAE6uzMj2ZifT9YgRrkSgzQX"))
        XCTAssertTrue(BitcoinAddress.isSegwit(candidate: "bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq"))
        XCTAssertTrue(BitcoinAddress.isSegwit(candidate: "bc1p5d7rjq7g6rdk2yhzks9smlaqtedr4dekq08ge8ztwac72sfr9rusxg3297"))
    }
    
    func testP2PKH() {
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "1LMcKyPmwebfygoeZP8E9jAMS2BcgH3Yip"))
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "19iy8HKpG5EbsqB2GUNVPUDbQxiTrPXpsx"))
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "1JKRgG4F7k1b7PbAhQ7heEuV5aTJDpK9TS"))
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2"))
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "17VZNX1SN5NtKa8UQFxwQbFeFc3iqRYhem"))
    }
    
    func testP2SH() {
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "3E13MQrZvPHqSSTsdQaZzZiYPzjEDT5VKE"))
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy"))
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "3EktnHQD7RiAE6uzMj2ZifT9YgRrkSgzQX"))
    }
    
    func testP2WPKH() {
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq"))
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "bc1qsr03qya584vkdqztxyat3d5s63pjfddy8vwrue"))
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4"))
    }
    
    func testP2WSH() {
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "bc1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3qccfmv3"))
    }
    
    func testP2TR() {
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "bc1p5d7rjq7g6rdk2yhzks9smlaqtedr4dekq08ge8ztwac72sfr9rusxg3297"))
        XCTAssertTrue(BitcoinAddress.isAddress(candidate: "bc1qzyda53xqwkqruex3mzwvpja04x23r572mygpgfc90qckdw2cwwaqr2h70u"))
    }
    
    func testInvalidAddresses() {
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "invalidBitcoinAddress"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: " 3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy "))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy."))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy_"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "_3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy_"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy______________________foo"))
        
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: " 1LMcKyPmwebfygoeZP8E9jAMS2BcgH3Yip"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "19iy8HKpG5EbsqB2GUNVPUDbQxiTrPXpsx "))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "1JKRgG4F7k1b7PbAhQ7heEuV5aTJDpK9TS."))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: ".1JKRgG4F7k1b7PbAhQ7heEuV5aTJDpK9TS"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "1JKRgG4F7k1b7PbAhQ7heEuV5aTJDpK9TS_"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "1JKRgG4F7k1b7PbAhQ7heEuV5aTJDpK9TS 1JKRgG4F7k1b7PbAhQ7heEuV5aTJDpK9TS"))
        
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: " bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq "))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq."))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: ".bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq>"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "bc1qar0srrr7xfkvy5l643>lydnw9re59gtzzwf5mdq"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "Bc1qar0srrr7xfkvy5l643>lydnw9re59gtzzwf5mdq"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "bC1qar0srrr7xfkvy5l643>lydnw9re59gtzzwf5mdq"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "bc1qar0srrr7xfkvy5l643>lydnw9re59gtzzwf5mdQ"))
        
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "bc1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3qccfmv3 "))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: " bc1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3qccfmv3"))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "bc1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3qccfmv3."))
        XCTAssertFalse(BitcoinAddress.isAddress(candidate: "bc1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccef+vpysxf3qccfmv3"))
    }
    
    func testIsTestnet() {
        XCTAssertTrue(BitcoinAddress.isTestnet(candidate: "tb1qlusewsse5fmnxvp3y4p9qayezl8upc0x8kpq08"))
        XCTAssertTrue(BitcoinAddress.isTestnet(candidate: "tb1qd0cupf70xz537e0lj8reg598gtlg4qp4gna8r8"))
    }
}
