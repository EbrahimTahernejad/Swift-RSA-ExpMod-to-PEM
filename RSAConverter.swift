//
//  RSAConverter.swift
//
//  Created by Ebrahim Tahernejad on 10/26/17.
//
//  MIT License
//
//  Copyright (c) 2017 Ebrahim Tahernejad
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

fileprivate extension String {
    
    func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf8.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
}


fileprivate extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0).trimmingCharacters(in: .whitespaces) }.joined()
    }
}

class RSAConverter {
    
    static private func prepadSigned(_ hexStr: String) -> String? {
        guard let msb = hexStr.first else {
            return nil
        }
        if (msb < "0" || msb > "7") {
            return "00" + hexStr
        } else {
            return hexStr
        }
    }
    
    static private func toHex(_ number: Int) -> String {
        let nstr = String(format:"%2X", number).trimmingCharacters(in: .whitespaces)
        if nstr.characters.count % 2 == 1 { return "0"+nstr }
        return nstr;
    }
    
    static private func encodeLengthHex(_ n: Int) -> String {
        if n <= 127 { return toHex(n) }
        else {
            let n_hex = toHex(n)
            let length_of_length_byte: Int = 128 + n_hex.characters.count / 2 // 0x80+numbytes
            return toHex(length_of_length_byte) + n_hex
        }
    }
    
    static func pemFrom(mod_b64: String, exp_b64: String) -> String? {
        guard let mod: String = Data(base64Encoded: mod_b64)?.hexEncodedString() else {
            return nil
        }
        guard let exp: String = Data(base64Encoded: exp_b64)?.hexEncodedString() else {
            return nil
        }
        return pemFrom(mod: mod, exp: exp)
    }
    
    static func pemFrom(mod: String, exp: String) -> String? {
        guard let modulus: String = prepadSigned(mod) else {
            return nil
        }
        guard let exponent: String = prepadSigned(exp) else {
            return nil
        }
        
        let modlen: Int = modulus.characters.count / 2
        let explen: Int = exponent.characters.count / 2
        
        let encoded_modlen: String = encodeLengthHex(modlen)
        let encoded_explen: String = encodeLengthHex(explen)
        
        let encoded_pubkey: String = "30" +
            encodeLengthHex(modlen + explen +
                encoded_modlen.characters.count / 2 +
                encoded_explen.characters.count / 2 + 2) +
            "02" + encoded_modlen + modulus +
            "02" + encoded_explen + exponent
        
        return encoded_pubkey.hexadecimal()?.base64EncodedString()
    }
}

