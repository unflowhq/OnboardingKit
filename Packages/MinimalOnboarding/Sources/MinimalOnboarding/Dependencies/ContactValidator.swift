//
//  ValidationService.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import Foundation

public protocol ContactValidating {
    func validateEmail(string: String) -> Bool
    func validatePhoneNumber(string: String) -> Bool
}

public struct ContactValidator: ContactValidating {
    public init() { }

    public func validateEmail(string: String) -> Bool {
        guard !string.isEmpty else { return false }
        let types: NSTextCheckingResult.CheckingType = [.link]
        guard let detector = try? NSDataDetector(types: types.rawValue) else {
            return false
        }
        let range = fullRange(for: string)
        let matches = detector.matches(in: string, options: [], range: range)
        guard matches.count == 1 else {
            return false
        }
        guard let result = matches.first, result.resultType == .link else { return false }
        guard NSEqualRanges(result.range, range) else { return false }
        return true
    }

    /// This is a very rudimentary check for a phone number, and will need to be extended in the real world.
    public func validatePhoneNumber(string: String) -> Bool {
        do {
            let regexString = #"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$"#
            let regex = try Regex(regexString)
            guard let match = string.firstMatch(of: regex) else { return false }
            return match.first != nil
        } catch {
            print("Unable to validate phone numbers at this time due to \(error.localizedDescription)")
            dump(error)
            return false
        }
    }
}

private extension ContactValidator {
    func fullRange(for string: String) -> NSRange {
        NSRange(location: 0, length: string.count)
    }
}
