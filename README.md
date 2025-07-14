# hash-to-curve-swift

A Swift library for hashing to a NIST P-256 elliptic curve, specifically wrapping BoringSSL's `EC_hash_to_curve_p256_xmd_sha256_sswu` function.

## Usage

```swift
import hash_to_curve

let dst = "QUUX-V01-CS02-with-P256_XMD:SHA-256_SSWU_RO_".data(using: .utf8)!
let msg = "abc".data(using: .utf8)!

// Get a compressed public key
let compressedKey = try hashToCurve(dst: dst, msg: msg)

// Get an uncompressed public key
let uncompressedKey = try hashToCurve(dst: dst, msg: msg, compressed: false)
```

I'm not going to maintain it or vice versa, just a PoC for further usage.