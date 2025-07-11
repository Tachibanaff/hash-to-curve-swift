import XCTest
@testable import hash_to_curve
import Foundation

final class hash_to_curveTests: XCTestCase {
    
    func testHashToCurveCompressed() throws {
        // Test vector from https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html#name-p256_xmd-sha-256_sswu_ro-
        let dst = "QUUX-V01-CS02-with-P256_XMD:SHA-256_SSWU_RO_".data(using: .utf8)!
        let msg = "abc".data(using: .utf8)!
        let expected = Data(hex: "020bb8b87485551aa43ed54f009230450b492fead5f1cc91658775dac4a3388a0f")
        
        let result = try hashToCurve(dst: dst, msg: msg, compressed: true)
        
        XCTAssertEqual(result, expected)
    }
    
    func testHashToCurveUncompressed() throws {
        // Test vector from https://www.ietf.org/archive/id/draft-irtf-cfrg-hash-to-curve-16.html#name-p256_xmd-sha-256_sswu_ro-
        let dst = "QUUX-V01-CS02-with-P256_XMD:SHA-256_SSWU_RO_".data(using: .utf8)!
        let msg = "abc".data(using: .utf8)!
        let expectedX = Data(hex: "0bb8b87485551aa43ed54f009230450b492fead5f1cc91658775dac4a3388a0f")
        let expectedY = Data(hex: "5c41b3d0731a27a7b14bc0bf0ccded2d8751f83493404c84a88e71ffd424212e")
        
        let result = try hashToCurve(dst: dst, msg: msg, compressed: false)
        
        XCTAssertEqual(result.count, 64)
        XCTAssertEqual(result.prefix(32), expectedX)
        XCTAssertEqual(result.suffix(32), expectedY)
    }
}

extension Data {
    init?(hex: String) {
        guard hex.count.isMultiple(of: 2) else {
            return nil
        }
        
        let chars = hex.map { $0 }
        let bytes = stride(from: 0, to: chars.count, by: 2)
            .map { String(chars[$0]) + String(chars[$0 + 1]) }
            .compactMap { UInt8($0, radix: 16) }
        
        guard hex.count / bytes.count == 2 else { return nil }
        self.init(bytes)
    }
}
