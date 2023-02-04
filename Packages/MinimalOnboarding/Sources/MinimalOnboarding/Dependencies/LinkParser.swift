//
//  LinkParser.swift
//  
//
//  Created by Alex Logan on 31/01/2023.
//

import Foundation

public protocol LinkParsing {
    func validate(url: URL) -> Link?
}

public struct LinkParser: LinkParsing {
    public init() { }

    public func validate(url: URL) -> Link? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        guard components.scheme == "minimal-onboarding" else { return nil }

        switch components.host {
        case "email-verification":
            return parseEmaiVerificationLink(url: url, components: components)
        default:
            return nil
        }
    }
}

private extension LinkParser {
    func parseEmaiVerificationLink(url: URL, components: URLComponents) -> Link? {
        guard let email = components.queryItems?.first(where: { $0.name == "email" })?.value else { return nil }
        return .emailVerification(email: email)
    }
}

public enum Link {
    case emailVerification(email: String)
}
