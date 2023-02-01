//
//  ConfirmEmailPage.swift
//  
//
//  Created by Alex Logan on 31/01/2023.
//

import SwiftUI

/// For an easy way to test this page, inside the overall flow, run `xcrun simctl openurl booted 'minimal-onboarding://email-verification?email=alex@alex.com'`.
/// You'll have to ensure the email provided in the URL matches the URL you've already entered, if you have gone via the email page.
struct ConfirmEmailPage: View {
    let email: String

    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.doubleCompactStack) {
            Header(text: "Your login link is on the way!", image: "Drum")
            VStack(alignment: .leading, spacing: DesignConstants.Spacing.compactStack) {
                Text("We've sent an email with a verification link to \(email).")
                    .typeStyle(.body)
                Text("If you're unable to find the email, please check your spam folder")
                    .typeStyle(.body)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct ConfirmEmailPage_Previews: PreviewProvider {
    static var previews: some View {
        MinimalThemeContainer {
            ConfirmEmailPage(email: "alex@unflow.com")
        }
    }
}
