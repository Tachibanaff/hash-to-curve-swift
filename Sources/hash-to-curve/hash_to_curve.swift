import Foundation
import CHashToCurve
import Crypto

public enum HashToCurveError: Error {
    case underlyingCryptoError
}

public func hashToCurve(dst: Data, msg: Data, compressed: Bool = true) throws -> Data {
    let group = CCryptoBoringSSL_EC_GROUP_new_by_curve_name(NID_X9_62_prime256v1)
    let point = CCryptoBoringSSL_EC_POINT_new(group)
    
    defer {
        CCryptoBoringSSL_EC_POINT_free(point)
        CCryptoBoringSSL_EC_GROUP_free(group)
    }
    
    var msgBytes = [UInt8](msg)
    let dstBytes = [UInt8](dst)
    
    let result = dstBytes.withUnsafeBufferPointer { dstPtr in
        msgBytes.withUnsafeMutableBufferPointer { msgPtr in
            CCryptoBoringSSL_EC_hash_to_curve_p256_xmd_sha256_sswu(
                group,
                point,
                dstPtr.baseAddress,
                dstPtr.count,
                msgPtr.baseAddress,
                msgPtr.count
            )
        }
    }
    
    guard result == 1 else {
        throw HashToCurveError.underlyingCryptoError
    }
    
    if compressed {
        var compressedBytes = [UInt8](repeating: 0, count: 33)
        let bytesWritten = compressedBytes.withUnsafeMutableBufferPointer { ptr in
            CCryptoBoringSSL_EC_POINT_point2oct(group, point, POINT_CONVERSION_COMPRESSED, ptr.baseAddress, ptr.count, nil)
        }
        guard bytesWritten == 33 else {
            throw HashToCurveError.underlyingCryptoError
        }
        return Data(compressedBytes)
    } else {
        var x = [UInt8](repeating: 0, count: 32)
        var y = [UInt8](repeating: 0, count: 32)
        
        x.withUnsafeMutableBufferPointer { xPtr in
            y.withUnsafeMutableBufferPointer { yPtr in
                let xBN = CCryptoBoringSSL_BN_new()
                let yBN = CCryptoBoringSSL_BN_new()
                
                defer {
                    CCryptoBoringSSL_BN_free(xBN)
                    CCryptoBoringSSL_BN_free(yBN)
                }
                
                CCryptoBoringSSL_EC_POINT_get_affine_coordinates_GFp(group, point, xBN, yBN, nil)
                
                CCryptoBoringSSL_BN_bn2bin(xBN, xPtr.baseAddress)
                CCryptoBoringSSL_BN_bn2bin(yBN, yPtr.baseAddress)
            }
        }
        
        return Data(x + y)
    }
}
